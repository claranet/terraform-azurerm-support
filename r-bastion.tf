resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

module "claranet_gallery_images" {
  source  = "claranet/claranet-gallery-images/azapi"
  version = "~> 7.0.0"

  azure_subscription_id = data.azurerm_client_config.current.subscription_id
  location_cli          = module.azure_region.location_cli
}

module "bastion_vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "~> 7.10.0"

  location            = var.location
  location_short      = var.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  vm_size     = var.vm_size
  custom_name = var.custom_bastion_vm_name

  # Network
  subnet_id         = module.support_subnet.subnet_id
  static_private_ip = var.bastion_private_ip

  # Naming
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  custom_public_ip_name = var.custom_bastion_public_ip_name
  custom_nic_name       = var.custom_bastion_nic_name
  custom_ipconfig_name  = var.custom_bastion_ipconfig_name
  custom_dns_label      = var.custom_bastion_dns_label
  custom_computer_name  = var.custom_bastion_vm_hostname

  # Diag/logs
  diagnostics_storage_account_name         = var.diagnostics_storage_account_name
  azure_monitor_data_collection_rule_id    = var.azure_monitor_data_collection_rule_id
  azure_monitor_agent_version              = var.azure_monitor_agent_version
  azure_monitor_agent_auto_upgrade_enabled = var.azure_monitor_agent_auto_upgrade_enabled

  # Boot scripts
  custom_data = var.bastion_custom_data
  user_data   = var.bastion_user_data

  public_ip_sku   = var.bastion_public_ip_sku
  public_ip_zones = var.bastion_public_ip_zones

  admin_username = var.admin_username
  admin_password = var.admin_password
  ssh_public_key = local.ssh_public_key

  identity = var.bastion_identity

  backup_policy_id              = var.bastion_backup_policy_id
  patch_mode                    = var.bastion_patch_mode
  maintenance_configuration_ids = var.bastion_maintenance_configuration_ids

  vm_image    = coalesce(var.bastion_vm_image, {})
  vm_image_id = local.vm_image_id

  # OS Disk
  os_disk_caching              = var.storage_os_disk_caching
  os_disk_custom_name          = var.custom_bastion_storage_os_disk_name
  os_disk_size_gb              = var.storage_os_disk_size_gb
  os_disk_overwrite_tags       = var.storage_os_disk_overwrite_tags
  os_disk_storage_account_type = var.storage_os_disk_account_type

  # AAD SSH Login option
  aad_ssh_login_enabled           = var.aad_ssh_login_enabled
  aad_ssh_login_extension_version = var.aad_ssh_login_extension_version
  aad_ssh_login_user_objects_ids  = var.aad_ssh_login_user_objects_ids
  aad_ssh_login_admin_objects_ids = var.aad_ssh_login_admin_objects_ids

  # Tags
  default_tags_enabled    = var.default_tags_enabled
  os_disk_tagging_enabled = var.storage_os_disk_tagging_enabled

  extra_tags            = merge(local.bastion_tags, var.bastion_extra_tags)
  public_ip_extra_tags  = merge(local.bastion_tags, var.public_ip_extra_tags)
  nic_extra_tags        = merge(local.bastion_tags, var.nic_extra_tags)
  os_disk_extra_tags    = merge(local.bastion_tags, var.storage_os_disk_extra_tags)
  extensions_extra_tags = merge(local.bastion_tags, var.extensions_extra_tags)
}
