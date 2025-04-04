variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "nsg_extra_tags" {
  description = "Additional tags to associate with your Network Security Group."
  type        = map(string)
  default     = {}
}

variable "bastion_extra_tags" {
  description = "Additional tags to associate with your bastion instance."
  type        = map(string)
  default     = {}
}

variable "nic_extra_tags" {
  description = "Additional tags to associate with your network interface."
  type        = map(string)
  default     = {}
}

variable "public_ip_extra_tags" {
  description = "Additional tags to associate with your public IP."
  type        = map(string)
  default     = {}
}

variable "bastion_os_disk_tagging_enabled" {
  description = "Should OS disk tagging be enabled? Defaults to `true`."
  type        = bool
  default     = true
}

variable "bastion_os_disk_extra_tags" {
  description = "Additional tags to set on the OS disk."
  type        = map(string)
  default     = {}
}

variable "extensions_extra_tags" {
  description = "Extra tags to set on the VM extensions."
  type        = map(string)
  default     = {}
}
