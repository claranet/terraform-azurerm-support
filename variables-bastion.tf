# Module Bastion / VM
variable "vm_size" {
  description = "Bastion virtual machine size"
  type        = string
}

variable "admin_username" {
  description = "Name of the admin user"
  type        = string
  default     = "claranet"
}

variable "ssh_public_key" {
  description = "SSH public key, generated if empty"
  type        = string
  default     = ""
}

variable "ssh_private_key" {
  description = "SSH private key, generated if empty"
  type        = string
  default     = ""
}

variable "storage_image_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machine"
  type        = string
  default     = "Canonical"
}

variable "storage_image_offer" {
  description = "Specifies the offer of the image used to create the virtual machine"
  type        = string
  default     = "UbuntuServer"
}

variable "storage_image_sku" {
  description = "Specifies the SKU of the image used to create the virtual machine"
  type        = string
  default     = "18.04-LTS"
}

variable "storage_image_id" {
  description = "Specifies the image ID used to create the virtual machine"
  type        = string
  default     = null
}

variable "storage_os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk"
  type        = string
  default     = "ReadWrite"
}

variable "storage_os_disk_size_gb" {
  description = "Specifies the size of the OS Disk in gigabytes"
  type        = string
}

# Azure Network Interface
variable "private_ip_bastion" {
  description = "Allows to define the private IP to associate with the bastion"
  type        = string
  default     = "10.10.1.10"
}

variable "public_ip_sku" {
  description = <<EOD
Public IP SKU attached to the bastion VM. Can be `null` if no public IP is needed.
If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private IP. 
Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory.
EOD
  type        = string
  default     = "Standard"
}

variable "public_ip_zones" {
  description = "Zones for public IP attached to the VM. Can be `null` if no zone distpatch."
  type        = list(number)
  default     = [1, 2, 3]
}
