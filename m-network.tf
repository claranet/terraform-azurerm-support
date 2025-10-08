module "support_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "~> 8.1.0"

  count = var.subnet.id == null ? 1 : 0

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = coalesce(var.virtual_network_resource_group_name, var.resource_group_name)
  virtual_network_name = var.virtual_network_name

  # Naming
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  custom_name = var.subnet_custom_name

  cidrs = try(var.subnet.cidrs, [])

  route_table_rg   = var.route_table_rg
  route_table_name = var.route_table_name

  service_endpoints           = var.service_endpoints
  service_endpoint_policy_ids = var.service_endpoint_policy_ids

  private_link_endpoint_enabled = var.private_link_endpoint_enabled
  private_link_service_enabled  = var.private_link_service_enabled

  default_outbound_access_enabled = var.default_outbound_access_enabled
}

moved {
  from = module.support_subnet
  to   = module.support_subnet[0]
}

resource "azurerm_subnet_network_security_group_association" "subnet_bastion_association" {
  subnet_id                 = try(module.support_subnet[0].id, var.subnet.id)
  network_security_group_id = module.support_nsg.id
}

module "support_nsg" {
  source  = "claranet/nsg/azurerm"
  version = "~> 8.1.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.virtual_network_resource_group_name, var.resource_group_name)
  location            = var.location
  location_short      = var.location_short

  # Naming
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  custom_name = var.network_security_group_custom_name

  ssh_inbound_allowed = true
  ssh_source_allowed  = var.admin_ssh_ips

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
