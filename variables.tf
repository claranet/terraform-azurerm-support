variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region to use"
}

variable "location-short" {
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

variable "extra_tags" {
  description = "Additional tags to associate with your network security group."
  type        = "map"
  default     = {}
}

# Module NSG
variable "admin_ssh_ips" {
  description = "Claranet IPs allowed to use SSH on bastion"
  type        = "string"
}

variable "nsg-name" {
  description = "Name used for nsg naming"
  type        = "string"
  default     = "test"
}

# Module Subnet 

variable "route_table_ids" {
  description = "The Route Table Ids list to associate with the subnet"
  type        = "list"
  default     = [""]
}

variable "network_security_group_ids" {
  description = "The Network Security Group Ids list to associate with the subnet"
  type        = "list"
  default     = [""]
}

variable "service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet"
  type        = "list"
  default     = []
}

variable "virtual_network_name" {
  description = "Virtual network name"
  type        = "string"
}

variable "subnet_cidr" {
  description = "The address prefix list to use for the subnet"
  type        = "list"
  default     = ["10.10.1.0/24"]
}

# Module Bastion

variable "vm_size" {
  description = "Bastion virtual machine size"
  type        = "string"
}

variable "custom_vm_name" {
  description = "VM Name as displayed on the console"
  type        = "string"
  default     = ""
}

variable "custom_vm_hostname" {
  description = "Bastion hostname"
  type        = "string"
  default     = ""
}

variable "custom_disk_name" {
  description = "Bastion disk name as displayed in the console"
  type        = "string"
  default     = ""
}

variable "custom_username" {
  description = "Default username to create on the bastion"
  type        = "string"
  default     = ""
}

variable "private_ip_bastion" {
  description = "Allows to define the private ip to associate with the bastion"
  type        = "string"
  default     = "10.10.1.10"
}

variable "support_dns_zone_name" {
  description = "Support DNS zone name"
  type        = "string"
}

variable "ssh_key_pub" {
  description = "Name of the SSH key pub to use"
  type        = "string"
}
