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
  resource_group_name = module.rg.name

  virtual_network_name = module.vnet.name

  # Bastion parameters
  bastion_vm_size         = "Standard_B1s"
  bastion_os_disk_size_gb = "32"

  admin_ssh_ips = var.admin_ssh_ips

  # Define your private ip bastion if you want to override it
  bastion_private_ip = "10.10.10.10"

  # Set to null to deactivate backup (not recommended)
  bastion_backup_policy_id = module.run.vm_backup_policy_id

  # Optional: Put your SSH key here
  ssh_public_key = tls_private_key.bastion.public_key_openssh

  # Define your subnets if you want to override it
  subnet = {
    cidrs = ["10.10.10.0/24"]
  }
  #  support_dns_zone_name = var.support_dns_zone_name

  # Diagnostics / logs
  diagnostics_storage_account_name      = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule_id = module.run.data_collection_rule_id
  log_analytics_workspace_guid          = module.run.log_analytics_workspace_guid
}
