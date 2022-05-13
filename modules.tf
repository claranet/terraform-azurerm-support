module "support_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "5.0.0"

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack
  name_prefix    = var.name_prefix

  resource_group_name  = coalesce(var.virtual_network_resource_group_name, var.resource_group_name)
  virtual_network_name = var.virtual_network_name

  custom_subnet_name = var.custom_bastion_subnet_name
  subnet_cidr_list   = var.subnet_cidr_list

  route_table_rg    = var.route_table_rg
  route_table_name  = var.route_table_name
  service_endpoints = var.service_endpoints
}

resource "azurerm_subnet_network_security_group_association" "subnet_bastion_association" {
  subnet_id                 = module.support_subnet.subnet_id
  network_security_group_id = module.support_nsg.network_security_group_id
}

module "support_nsg" {
  source  = "claranet/nsg/azurerm"
  version = "5.1.0"

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
  source = "github.com/claranet/terraform-azurerm-bastion-vm.git?ref=v5.3.0"

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
  custom_vm_name     = var.custom_vm_name
  custom_vm_hostname = var.custom_vm_hostname

  # VM Network
  subnet_bastion_id  = module.support_subnet.subnet_id
  private_ip_bastion = var.private_ip_bastion

  # VM Params & identity
  vm_size         = var.vm_size
  admin_username  = var.admin_username
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key

  # VM OS Image ref
  storage_image_publisher = var.storage_image_publisher
  storage_image_offer     = var.storage_image_offer
  storage_image_sku       = var.storage_image_sku
  storage_image_id        = var.storage_image_id

  # VM OS Disk params
  storage_os_disk_custom_name = var.storage_os_disk_custom_name
  storage_os_disk_caching     = var.storage_os_disk_caching
  storage_os_disk_size_gb     = var.storage_os_disk_size_gb

  # VM Public IP params
  custom_public_ip_name = var.custom_public_ip_name
  custom_ipconfig_name  = var.custom_ipconfig_name
  custom_nic_name       = var.custom_nic_name
  public_ip_sku         = var.public_ip_sku

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
}
