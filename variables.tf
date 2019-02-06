variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region to use"
}

variable "location_short" {
  description = "Short string for Azure location"
}

variable "environment" {
  description = "Project environment"
}

variable "stack" {
  description = "Project stack name"
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = "string"
}

variable "nsg-name" {
  description = "Name used for nsg naming"
  type        = "string"
  default     = "test"
}

variable "extra_tags" {
  description = "Additional tags to associate with your network security group."
  type        = "map"
  default     = {}
}

variable "virtual_network_name" {
  description = "Virtual network name"
  type        = "string"
}

variable "subnet_cidr" {
  description = "The address prefix list to use for the subnet"
  type        = "list"
}

variable "admin_ssh_ips" {
  description = "Claranet IPs allowed to use SSH on bastion"
  type        = "string"
}
