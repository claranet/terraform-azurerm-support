variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

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
  description = "Allows to define the private ip to associate with the bastion"
  type        = string
  default     = "10.10.1.10"
}

variable "public_ip_sku" {
  description = <<EOD
Public IP SKU attached to the bastion VM. Can be `null` if no public IP is needed.
If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private ip. 
Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory.
EOD
  type        = string
  default     = "Standard"
}
