module "support_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "~> 6.3.0"

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack
  name_prefix    = var.name_prefix

  resource_group_name  = coalesce(var.virtual_network_resource_group_name, var.resource_group_name)
  virtual_network_name = var.virtual_network_name

  custom_subnet_name = var.custom_subnet_name
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
  version = "~> 7.6.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.virtual_network_resource_group_name, var.resource_group_name)
  location            = var.location
  location_short      = var.location_short

  # Naming
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  custom_network_security_group_name = var.custom_security_group_name

  ssh_inbound_allowed = true
  allowed_ssh_source  = var.admin_ssh_ips

  # Custom
  additional_rules = var.nsg_additional_rules

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
