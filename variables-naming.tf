# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = "bastion"
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `custom_*_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_vm_name" {
  description = "VM Name as displayed on the console"
  type        = string
  default     = ""
}

variable "custom_vm_hostname" {
  description = "Bastion hostname"
  type        = string
  default     = ""
}

variable "custom_bastion_subnet_name" {
  description = "Custom name for bastion subnet"
  type        = string
  default     = null
}

variable "custom_security_group_name" {
  description = "Custom name for network security group"
  type        = string
  default     = null
}

variable "storage_os_disk_custom_name" {
  description = "Bastion OS disk name as displayed in the console"
  type        = string
  default     = ""
}

variable "custom_public_ip_name" {
  description = "Custom name for public IP"
  type        = string
  default     = null
}

variable "custom_ipconfig_name" {
  description = "Custom name for IP Configuration"
  type        = string
  default     = null
}

variable "custom_nic_name" {
  description = "Custom name for NIC"
  type        = string
  default     = null
}
