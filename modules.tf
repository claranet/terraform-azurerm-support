module "support-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "4.1.0"

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack
  name_prefix    = var.name_prefix

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name

  custom_subnet_name = var.custom_bastion_subnet_name
  subnet_cidr_list   = var.subnet_cidr_list

  route_table_id    = var.route_table_id
  service_endpoints = var.service_endpoints

  # Because of the Terraform error about resolving dependencies with count, cannot use this attribute.
  # network_security_group_id = module.support-network-security-group.network_security_group_id
}

resource "azurerm_subnet_network_security_group_association" "subnet_bastion_association" {
  subnet_id                 = module.support-subnet.subnet_id
  network_security_group_id = module.support-network-security-group.network_security_group_id
}

module "support-network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "4.1.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short
  name_prefix         = var.name_prefix

  custom_network_security_group_name = var.custom_security_group_name

  extra_tags = var.nsg_extra_tags
}

resource "azurerm_network_security_rule" "ssh_rule" {
  network_security_group_name = module.support-network-security-group.network_security_group_name
  resource_group_name         = var.resource_group_name

  name        = "SSH"
  description = "Allow Admin Claranet SSH Bastion"

  priority                   = "500"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefixes    = var.admin_ssh_ips
  destination_address_prefix = var.private_ip_bastion
}

module "bastion" {
  source = "github.com/claranet/terraform-azurerm-bastion-vm.git?ref=v4.1.0"

  client_name         = var.client_name
  location            = var.location
  location_short      = var.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix

  # Custom bastion VM
  custom_vm_name     = var.custom_vm_name
  custom_vm_hostname = var.custom_vm_hostname

  # VM Network
  subnet_bastion_id  = module.support-subnet.subnet_id
  private_ip_bastion = var.private_ip_bastion

  # VM Params & identity
  vm_size          = var.vm_size
  admin_username   = var.admin_username
  ssh_key_pub      = file(var.ssh_key_pub)
  private_key_path = var.private_key_path

  # VM OS Image ref
  storage_image_publisher = var.storage_image_publisher
  storage_image_offer     = var.storage_image_offer
  storage_image_sku       = var.storage_image_sku

  # VM OS Disk params
  storage_os_disk_custom_name       = var.storage_os_disk_custom_name
  storage_os_disk_caching           = var.storage_os_disk_caching
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  storage_os_disk_size_gb           = var.storage_os_disk_size_gb

  # VM Public IP params
  custom_publicip_name = var.custom_publicip_name
  custom_ipconfig_name = var.custom_ipconfig_name
  custom_nic_name      = var.custom_nic_name

  # vM Diagnostics/logs
  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

  # Tags
  bastion_extra_tags = var.bastion_extra_tags
  ani_extra_tags     = var.ani_extra_tags
  pubip_extra_tags   = var.pubip_extra_tags
}
