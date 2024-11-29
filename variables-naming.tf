# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = "bastion"
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

# Custom naming override
variable "bastion_custom_name" {
  description = "VM Name as displayed on the console."
  type        = string
  default     = ""
}

variable "bastion_custom_hostname" {
  description = "Custom Bastion hostname."
  type        = string
  default     = ""
}

variable "subnet_custom_name" {
  description = "Custom name for Subnet."
  type        = string
  default     = null
}

variable "network_security_group_custom_name" {
  description = "Custom name for Network Security Group."
  type        = string
  default     = null
}

variable "bastion_os_disk_custom_name" {
  description = "Custom name for Bastion OS disk."
  type        = string
  default     = ""
}

variable "bastion_public_ip_custom_name" {
  description = "Custom name for public IP."
  type        = string
  default     = null
}

variable "bastion_ipconfig_custom_name" {
  description = "Custom name for IP Configuration."
  type        = string
  default     = null
}

variable "bastion_dns_label_custom_name" {
  description = "Custom name for DNS label."
  type        = string
  default     = null
}

variable "bastion_nic_custom_name" {
  description = "Custom name for NIC."
  type        = string
  default     = null
}
