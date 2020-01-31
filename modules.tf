module "support-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "2.0.3"

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_cidr_list     = [var.subnet_cidr]

  route_table_count = var.route_table_count
  route_table_ids   = var.route_table_ids

  network_security_group_count = "1"
  network_security_group_ids   = [module.support-network-security-group.network_security_group_id]

  service_endpoints = var.service_endpoints
}

module "support-network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "2.0.1"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short
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
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion-vm.git?ref=v2.1.0"

  client_name         = var.client_name
  location            = var.location
  location_short      = var.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix

  subnet_bastion_id  = join(",", module.support-subnet.subnet_ids)
  private_ip_bastion = var.private_ip_bastion

  vm_size     = var.vm_size
  ssh_key_pub = file(var.ssh_key_pub)

  private_key_path = var.private_key_path

  delete_os_disk_on_termination     = var.delete_os_disk_on_termination
  storage_image_publisher           = var.storage_image_publisher
  storage_image_offer               = var.storage_image_offer
  storage_image_sku                 = var.storage_image_sku
  storage_os_disk_caching           = var.storage_os_disk_caching
  storage_os_disk_create_option     = var.storage_os_disk_create_option
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  storage_os_disk_size_gb           = var.storage_os_disk_size_gb

  custom_vm_name     = var.custom_vm_name
  custom_vm_hostname = var.custom_vm_hostname
  custom_disk_name   = var.custom_disk_name
  admin_username     = var.admin_username

  bastion_extra_tags = var.bastion_extra_tags
  ani_extra_tags     = var.ani_extra_tags
  pubip_extra_tags   = var.pubip_extra_tags
}
