variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which store VM diagnostics."
  type        = string
}

## Logs & monitoring variables
variable "azure_monitor_data_collection_rule_id" {
  description = "Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` if legacy agent is used."
  type        = string
}

variable "azure_monitor_agent_version" {
  description = "Azure Monitor Agent extension version."
  type        = string
  default     = "1.12"
}

variable "azure_monitor_agent_auto_upgrade_enabled" {
  description = "Automatically update agent when publisher releases a new version of the agent."
  type        = bool
  default     = false
}
