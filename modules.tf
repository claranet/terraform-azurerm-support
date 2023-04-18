module "support_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "6.1.0"

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack
  name_prefix    = var.name_prefix

  resource_group_name  = coalesce(var.virtual_network_resource_group_name, var.resource_group_name)
  virtual_network_name = var.virtual_network_name

  custom_subnet_name = var.custom_bastion_subnet_name
  subnet_cidr_list   = var.subnet_cidr_list

  route_table_rg   = var.route_table_rg
  route_table_name = var.route_table_name

  service_endpoints           = var.service_endpoints
  service_endpoint_policy_ids = var.service_endpoint_policy_ids

  private_link_endpoint_enabled = var.private_link_endpoint_enabled
  private_link_service_enabled  = var.private_link_service_enabled
}

resource "azurerm_subnet_network_security_group_association" "subnet_bastion_association" {
  subnet_id                 = module.support_subnet.subnet_id
  network_security_group_id = module.support_nsg.network_security_group_id
}

module "support_nsg" {
  source  = "claranet/nsg/azurerm"
  version = "7.3.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.virtual_network_resource_group_name, var.resource_group_name)
  location            = var.location
  location_short      = var.location_short

  # Naming
  name_prefix    = local.name_prefix
  name_suffix    = local.name_suffix
  use_caf_naming = var.use_caf_naming

  custom_network_security_group_name = var.custom_security_group_name

  # Custom
  additional_rules = var.additional_rules

  # Flow Logs
  flow_log_enabled                               = var.flow_log_enabled
  flow_log_logging_enabled                       = var.flow_log_logging_enabled
  network_watcher_name                           = var.network_watcher_name
  network_watcher_resource_group_name            = var.network_watcher_resource_group_name
  flow_log_storage_account_id                    = var.flow_log_storage_account_id
  flow_log_retention_policy_enabled              = var.flow_log_retention_policy_enabled
  flow_log_retention_policy_days                 = var.flow_log_retention_policy_days
  flow_log_traffic_analytics_enabled             = var.flow_log_traffic_analytics_enabled
  log_analytics_workspace_guid                   = var.log_analytics_workspace_guid
  log_analytics_workspace_location               = var.log_analytics_workspace_location
  log_analytics_workspace_id                     = var.log_analytics_workspace_id
  flow_log_traffic_analytics_interval_in_minutes = var.flow_log_traffic_analytics_interval_in_minutes
  flow_log_location                              = var.flow_log_location

  # Tags
  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.nsg_extra_tags
}

resource "azurerm_network_security_rule" "ssh_rule" {
  network_security_group_name = module.support_nsg.network_security_group_name
  resource_group_name         = coalesce(var.virtual_network_resource_group_name, var.resource_group_name)

  name        = "SSH"
  description = "Allow Admin Claranet SSH Bastion"

  priority                   = "500"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefixes    = var.admin_ssh_ips
  destination_address_prefix = coalesce(var.private_ip_bastion, module.bastion.bastion_network_interface_private_ip)
}

module "bastion" {
  source = "git@git.fr.clara.net:claranet/projects/cloud/azure/terraform/modules/bastion-vm.git?ref=AZ-1064_add_parameter"

  client_name         = var.client_name
  location            = var.location
  location_short      = var.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  # Naming
  name_prefix    = local.name_prefix
  name_suffix    = local.name_suffix
  use_caf_naming = var.use_caf_naming

  # Custom bastion VM
  custom_vm_name                = var.custom_vm_name
  custom_vm_hostname            = var.custom_vm_hostname
  backup_policy_id              = var.backup_policy_id
  patch_mode                    = var.patch_mode
  maintenance_configuration_ids = var.maintenance_configuration_ids
  identity                      = var.identity

  # VM Network
  subnet_bastion_id        = module.support_subnet.subnet_id
  private_ip_bastion       = var.private_ip_bastion
  custom_facing_ip_address = var.custom_facing_ip_address

  # VM Params & identity
  vm_size         = var.vm_size
  vm_zone         = var.vm_zone
  admin_username  = var.admin_username
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key

  # VM OS Image ref
  storage_image_publisher      = var.storage_image_publisher
  storage_image_offer          = var.storage_image_offer
  storage_image_sku            = var.storage_image_sku
  storage_image_id             = var.storage_image_id
  storage_os_disk_account_type = var.storage_os_disk_account_type

  # VM OS Disk params
  storage_os_disk_custom_name = var.storage_os_disk_custom_name
  storage_os_disk_caching     = var.storage_os_disk_caching
  storage_os_disk_size_gb     = var.storage_os_disk_size_gb

  # VM Public IP params
  custom_public_ip_name = var.custom_public_ip_name
  custom_ipconfig_name  = var.custom_ipconfig_name
  custom_nic_name       = var.custom_nic_name
  public_ip_sku         = var.public_ip_sku
  public_ip_zones       = var.public_ip_zones

  # VM Diagnostics/logs
  diagnostics_storage_account_name         = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token    = var.diagnostics_storage_account_sas_token
  use_legacy_monitoring_agent              = var.use_legacy_monitoring_agent
  azure_monitor_data_collection_rule_id    = var.azure_monitor_data_collection_rule_id
  azure_monitor_agent_version              = var.azure_monitor_agent_version
  azure_monitor_agent_auto_upgrade_enabled = var.azure_monitor_agent_auto_upgrade_enabled
  log_analytics_workspace_guid             = var.log_analytics_workspace_guid
  log_analytics_workspace_key              = var.log_analytics_workspace_key
  log_analytics_agent_enabled              = var.log_analytics_agent_enabled
  log_analytics_agent_version              = var.log_analytics_agent_version

  # Tags
  default_tags_enabled            = var.default_tags_enabled
  bastion_extra_tags              = var.bastion_extra_tags
  ani_extra_tags                  = var.ani_extra_tags
  pubip_extra_tags                = var.pubip_extra_tags
  storage_os_disk_tagging_enabled = var.storage_os_disk_tagging_enabled
  storage_os_disk_extra_tags      = var.storage_os_disk_extra_tags
  extensions_extra_tags           = var.extensions_extra_tags
}
