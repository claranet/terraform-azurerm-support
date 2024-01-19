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
variable "custom_bastion_vm_name" {
  description = "VM Name as displayed on the console."
  type        = string
  default     = ""
}

variable "custom_bastion_vm_hostname" {
  description = "Custom Bastion hostname."
  type        = string
  default     = ""
}

variable "custom_subnet_name" {
  description = "Custom name for Subnet."
  type        = string
  default     = null
}

variable "custom_security_group_name" {
  description = "Custom name for Network Security Group."
  type        = string
  default     = null
}

variable "custom_bastion_storage_os_disk_name" {
  description = "Custom name for Bastion OS disk."
  type        = string
  default     = ""
}

variable "custom_bastion_public_ip_name" {
  description = "Custom name for public IP."
  type        = string
  default     = null
}

variable "custom_bastion_ipconfig_name" {
  description = "Custom name for IP Configuration."
  type        = string
  default     = null
}

variable "custom_bastion_dns_label" {
  description = "Custom name for DNS label."
  type        = string
  default     = null
}

variable "custom_bastion_nic_name" {
  description = "Custom name for NIC."
  type        = string
  default     = null
}
