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

variable "custom_security_group_name" {
  description = "Custom name for network security group"
  type        = string
  default     = null
}

variable "nsg_extra_tags" {
  description = "Additional tags to associate with your Network Security Group."
  type        = map(string)
  default     = {}
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

variable "custom_bastion_subnet_name" {
  description = "Custom name for bastion subnet"
  type        = string
  default     = null
}

# Module Bastion / VM
variable "name_prefix" {
  description = "Optional prefix for resources naming"
  type        = string
  default     = "bastion-"
}

variable "vm_size" {
  description = "Bastion virtual machine size"
  type        = string
}

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

variable "admin_username" {
  description = "Name of the admin user"
  type        = string
  default     = "claranet"
}

variable "ssh_key_pub" {
  description = "Name of the SSH key pub to use"
  type        = string
}

variable "private_key_path" {
  description = "Root SSH private key path"
  type        = string
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

variable "storage_os_disk_custom_name" {
  description = "Bastion OS disk name as displayed in the console"
  type        = string
  default     = ""
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

variable "bastion_extra_tags" {
  description = "Additional tags to associate with your bastion instance."
  type        = map(string)
  default     = {}
}

# Azure Network Interface
variable "private_ip_bastion" {
  description = "Allows to define the private ip to associate with the bastion"
  type        = string
  default     = "10.10.1.10"
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
  description = "Custom name fir NIC"
  type        = string
  default     = null
}

variable "ani_extra_tags" {
  description = "Additional tags to associate with your network interface."
  type        = map(string)
  default     = {}
}

variable "pubip_extra_tags" {
  description = "Additional tags to associate with your public ip."
  type        = map(string)
  default     = {}
}

# Diagnostics/Logs
variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which store vm diagnostics"
  type        = string
}

variable "diagnostics_storage_account_sas_token" {
  description = "SAS token of the Storage Account in which store vm diagnostics"
  type        = string
}
