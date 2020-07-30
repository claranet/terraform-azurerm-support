locals {
  subnet_name = "bastion-${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-subnet"
}

module "support-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "3.0.0"

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name

  custom_subnet_names = [local.subnet_name]
  subnet_cidr_list    = [var.subnet_cidr]

  route_table_ids = var.route_table_ids

  network_security_group_ids = {
    "${local.subnet_name}" = module.support-network-security-group.network_security_group_id[0]
  }

  service_endpoints = var.service_endpoints
}

module "support-network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "3.0.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short
  name_prefix         = var.name_prefix
}

resource "azurerm_network_security_rule" "ssh_rule" {
  network_security_group_name = module.support-network-security-group.network_security_group_name[0]
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
  source = "github.com/claranet/terraform-azurerm-bastion-vm.git?ref=v3.1.0"

  client_name         = var.client_name
  location            = var.location
  location_short      = var.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix

  subnet_bastion_id  = module.support-subnet.subnet_ids[0]
  private_ip_bastion = var.private_ip_bastion

  vm_size     = var.vm_size
  ssh_key_pub = file(var.ssh_key_pub)

  private_key_path = var.private_key_path

  storage_image_publisher           = var.storage_image_publisher
  storage_image_offer               = var.storage_image_offer
  storage_image_sku                 = var.storage_image_sku
  storage_os_disk_caching           = var.storage_os_disk_caching
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  storage_os_disk_size_gb           = var.storage_os_disk_size_gb

  custom_vm_name     = var.custom_vm_name
  custom_vm_hostname = var.custom_vm_hostname
  custom_disk_name   = var.custom_disk_name
  admin_username     = var.admin_username

  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

  bastion_extra_tags = var.bastion_extra_tags
  ani_extra_tags     = var.ani_extra_tags
  pubip_extra_tags   = var.pubip_extra_tags
}
