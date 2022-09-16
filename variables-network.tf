# Module NSG
variable "admin_ssh_ips" {
  description = "Claranet IPs allowed to use SSH on bastion"
  type        = list(string)
}

# Module Subnet
variable "route_table_name" {
  description = "The Route Table name to associate with the subnet"
  type        = string
  default     = null
}

variable "route_table_rg" {
  description = "The Route Table RG to associate with the subnet. Default is the same RG than the subnet."
  type        = string
  default     = null
}

variable "service_endpoints" {
  description = "The list of Service endpoints to associate with the support subnet"
  type        = list(string)
  default     = []
}

variable "virtual_network_name" {
  description = "Virtual network name"
  type        = string
}

variable "virtual_network_resource_group_name" {
  description = "Virtual network resource group name, default to `resource_group_name` if empty"
  type        = string
  default     = ""
}

variable "subnet_cidr_list" {
  description = "The address prefixes to use for the subnet"
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

