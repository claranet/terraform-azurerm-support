resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

module "claranet_gallery_images" {
  source  = "claranet/claranet-gallery-images/azapi"
  version = "~> 8.1.0"

  azure_subscription_id = data.azurerm_client_config.current.subscription_id
  location_cli          = module.azure_region.location_cli
}

module "bastion_vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "~> 8.0.0"

  location            = var.location
  location_short      = var.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  vm_size     = var.bastion_vm_size
  custom_name = var.bastion_custom_name

  # Network
  subnet = {
    id = try(module.support_subnet[0].id, var.subnet.id)
  }
  static_private_ip                  = var.bastion_private_ip
  nic_accelerated_networking_enabled = var.bastion_nic_accelerated_networking_enabled

  # Naming
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  public_ip_custom_name        = var.bastion_public_ip_custom_name
  nic_custom_name              = var.bastion_nic_custom_name
  ip_configuration_custom_name = var.bastion_ipconfig_custom_name
  custom_dns_label             = var.bastion_dns_label_custom_name
  computer_name                = var.bastion_custom_hostname
  os_disk_custom_name          = var.bastion_os_disk_custom_name
  dcr_custom_name              = var.bastion_dcr_custom_name

  # Diag/logs
  diagnostics_storage_account_name         = var.diagnostics_storage_account_name
  azure_monitor_agent_version              = var.azure_monitor_agent_version
  azure_monitor_agent_auto_upgrade_enabled = var.azure_monitor_agent_auto_upgrade_enabled
  azure_monitor_data_collection_rule = {
    id = var.azure_monitor_data_collection_rule_id
  }

  # Boot scripts
  custom_data = var.bastion_custom_data
  user_data   = var.bastion_user_data

  public_ip_enabled = var.bastion_public_ip_enabled
  public_ip_zones   = var.bastion_public_ip_zones

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  ssh_public_key                  = local.ssh_public_key
  disable_password_authentication = var.disable_password_authentication

  identity = var.bastion_identity

  backup_policy = {
    id = var.bastion_backup_policy_id
  }
  patch_mode                     = var.bastion_patch_mode
  maintenance_configurations_ids = var.bastion_maintenance_configurations_ids
  encryption_at_host_enabled     = var.encryption_at_host_enabled
  vtpm_enabled                   = var.vtpm_enabled

  vm_image = var.bastion_vm_image != null ? var.bastion_vm_image : {
    publisher = "Claranet"
    offer     = "Ubuntu"
    sku       = "22_04-lts"
    version   = "latest"
  }
  vm_image_id = local.vm_image_id

  # OS Disk
  os_disk_caching              = var.bastion_os_disk_caching
  os_disk_size_gb              = var.bastion_os_disk_size_gb
  os_disk_storage_account_type = var.bastion_os_disk_account_type

  # Entra ID (AAD) SSH Login option
  entra_ssh_login_enabled           = var.entra_ssh_login_enabled
  entra_ssh_login_extension_version = var.entra_ssh_login_extension_version
  entra_ssh_login_user_objects_ids  = var.entra_ssh_login_user_objects_ids
  entra_ssh_login_admin_objects_ids = var.entra_ssh_login_admin_objects_ids

  # Tags
  default_tags_enabled    = var.default_tags_enabled
  os_disk_tagging_enabled = var.bastion_os_disk_tagging_enabled

  extra_tags            = merge(local.bastion_tags, var.bastion_extra_tags)
  public_ip_extra_tags  = merge(local.bastion_tags, var.public_ip_extra_tags)
  nic_extra_tags        = merge(local.bastion_tags, var.nic_extra_tags)
  os_disk_extra_tags    = merge(local.bastion_tags, var.bastion_os_disk_extra_tags)
  extensions_extra_tags = merge(local.bastion_tags, var.extensions_extra_tags)
}
