# Module Bastion / VM
variable "vm_size" {
  description = "Bastion virtual machine size."
  type        = string
}

# Authentication
variable "disable_password_authentication" {
  description = "Option to disable or enable password authentication if admin password is not set."
  type        = bool
  default     = true
}

variable "admin_password" {
  description = "Password for the administrator account of the virtual machine."
  type        = string
  default     = null
}

variable "admin_username" {
  description = "Name of the administrator user."
  type        = string
  default     = "claranet"
}

variable "ssh_public_key" {
  description = "SSH public key, generated if empty."
  type        = string
  default     = null
}

variable "bastion_vm_image" {
  description = "Bastion Virtual Machine source image information. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference). This variable cannot be used if `vm_image_id` is already defined. Defaults to Claranet image."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "bastion_vm_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null. Defaults to Claranet image."
  type        = string
  default     = null
}

variable "storage_os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk."
  type        = string
  default     = "ReadWrite"
}

variable "storage_os_disk_size_gb" {
  description = "Specifies the size of the OS Disk in gigabytes."
  type        = string
}

variable "storage_os_disk_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`."
  type        = string
  default     = "Premium_ZRS"
}

# Azure Network Interface
variable "bastion_private_ip" {
  description = "Allows to define the private IP to associate with the bastion."
  type        = string
  default     = null
}

variable "bastion_public_ip_sku" {
  description = <<EOD
Public IP SKU attached to the bastion VM. Can be `null` if no public IP is needed.
If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private IP.
Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory.
EOD
  type        = string
  default     = "Standard"
}

variable "bastion_public_ip_zones" {
  description = "Zones for public IP attached to the VM. Can be `null` if no zone distpatch."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "bastion_nic_accelerated_networking_enabled" {
  description = "Should Accelerated Networking be enabled? Defaults to false."
  type        = bool
  default     = false
}

## Identity variables
variable "bastion_identity" {
  description = "Map with identity block informations as described in [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity)."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

## Backup variable
variable "bastion_backup_policy_id" {
  description = "Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup)."
  type        = string
}

# Update Management
variable "bastion_patch_mode" {
  description = "Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`"
  type        = string
  default     = "ImageDefault"
}

variable "bastion_maintenance_configuration_ids" {
  description = "List of maintenance configurations to attach to this VM."
  type        = list(string)
  default     = []
}

variable "bastion_custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for the bastion. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "bastion_user_data" {
  description = "The Base64-Encoded User Data which should be used for the bastion."
  type        = string
  default     = null
}
