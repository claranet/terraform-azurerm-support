# Module NSG
variable "admin_ssh_ips" {
  description = "Claranet IPs allowed to use SSH on bastion."
  type        = list(string)
}

variable "nsg_additional_rules" {
  description = "Additional network security group rules to add. For arguments please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule#argument-reference."
  type = list(object({
    priority  = number
    name      = string
    direction = optional(string)
    access    = optional(string)
    protocol  = optional(string)

    source_port_range  = optional(string)
    source_port_ranges = optional(list(string))

    destination_port_range  = optional(string)
    destination_port_ranges = optional(list(string))

    source_address_prefix   = optional(string)
    source_address_prefixes = optional(list(string))

    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  default = []
}

# Module Subnet
variable "default_outbound_access_enabled" {
  description = "Enable or Disable default_outbound_access. See https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access"
  type        = bool
  default     = false
}

variable "route_table_name" {
  description = "The Route Table name to associate with the subnet."
  type        = string
  default     = null
}

variable "route_table_rg" {
  description = "The Route Table RG to associate with the subnet. Default is the same RG than the subnet."
  type        = string
  default     = null
}

variable "service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet."
  type        = list(string)
  default     = []
}

variable "service_endpoint_policy_ids" {
  description = "The list of IDs of Service Endpoint Policies to associate with the subnet."
  type        = list(string)
  default     = null
}

variable "private_link_endpoint_enabled" {
  description = "Enable or disable network policies for the Private Endpoint on the subnet."
  type        = bool
  default     = null
}

variable "private_link_service_enabled" {
  description = "Enable or disable network policies for the Private Link Service on the subnet."
  type        = bool
  default     = null
}

variable "virtual_network_name" {
  description = "Bastion VM virtual network name."
  type        = string
}

variable "virtual_network_resource_group_name" {
  description = "Bastion VM virtual network resource group name, default to `resource_group_name` if empty."
  type        = string
  default     = ""
}

variable "subnet_cidr_list" {
  description = "The address prefixes to use for the subnet."
  type        = list(string)
}
