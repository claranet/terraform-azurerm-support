module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  monitoring_function_enabled = false
  vm_monitoring_enabled       = true
  backup_vm_enabled           = true
  update_center_enabled       = false

  recovery_vault_cross_region_restore_enabled = true
  vm_backup_daily_policy_retention            = 31
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

module "support" {
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/module/support.git?ref=vX.X.X"

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure_network_vnet.virtual_network_name

  # bastion parameters
  vm_size                 = "Standard_B1s"
  storage_os_disk_size_gb = "32"

  admin_ssh_ips = var.admin_ssh_ips

  # Define your private ip bastion if you want to override it
  private_ip_bastion = "10.10.10.10"

  # Set to null to deactivate backup
  backup_policy_id = module.run.vm_backup_policy_id

  # Optional: Put your SSH key here
  ssh_public_key  = tls_private_key.bastion.public_key_openssh
  ssh_private_key = tls_private_key.bastion.private_key_pem

  # Define your subnets if you want to override it
  subnet_cidr_list = ["10.10.10.0/24"]
  #  support_dns_zone_name = var.support_dns_zone_name

  # Diag/logs
  diagnostics_storage_account_name      = module.run.logs_storage_account_name
  diagnostics_storage_account_sas_token = null # used by legacy agent only
  azure_monitor_data_collection_rule_id = module.run.data_collection_rule_id
  log_analytics_workspace_guid          = module.run.log_analytics_workspace_guid
  log_analytics_workspace_key           = module.run.log_analytics_workspace_primary_key
}
