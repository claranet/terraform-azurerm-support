module "support-subnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=AZ-5-az-subnet"

  environment    = "${var.environment}"
  location-short = "${var.location-short}"
  client_name    = "${var.client_name}"
  stack          = "${var.stack}"

  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  subnet_cidr          = "${var.subnet_cidr}"

  route_table_ids            = "${var.route_table_ids}"
  service_endpoints          = "${var.service_endpoints}"
  network_security_group_ids = ["${module.support-network-security-group.network_security_group_id}"]
}

module "support-network-security-group" {
  source                     = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/nsg.git?ref=AZ-5_Add_nsg_module"
  client_name                = "${var.client_name}"
  environment                = "${var.environment}"
  stack                      = "${var.stack}"
  resource_group_name        = "${var.resource_group_name}"
  location                   = "${var.location}"
  location_short             = "${var.location-short}"
  security_group_name_prefix = "${var.nsg-prefix}"

  custom_rules = [
    {
      name                       = "SSH"
      priority                   = "500"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      destination_port_range     = "22"
      source_address_prefix      = "${var.admin_ssh_ips}"
      destination_address_prefix = "${var.private_ip_bastion}"
      description                = "Allow Admin Claranet SSH Bastion"
    },
  ]
}

module "bastion" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion.git?ref=AZ-11-bump-salt-to-use-ansible"

  client_name         = "${var.client_name}"
  location            = "${var.location}"
  location-short      = "${var.location-short}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"
  name                = "${var.bastion-name}"

  subnet_bastion_id  = "${join(",", module.support-subnet.subnet_ids)}"
  private_ip_bastion = "${var.private_ip_bastion}"

  vm_size     = "${var.vm_size}"
  ssh_key_pub = "${file(var.ssh_key_pub)}"

  private_key_path = "${var.private_key_path}"

  delete_os_disk_on_termination     = "${var.delete_os_disk_on_termination}"
  storage_image_publisher           = "${var.storage_image_publisher}"
  storage_image_offer               = "${var.storage_image_offer}"
  storage_image_sku                 = "${var.storage_image_sku}"
  storage_os_disk_caching           = "${var.storage_os_disk_caching}"
  storage_os_disk_create_option     = "${var.storage_os_disk_create_option}"
  storage_os_disk_managed_disk_type = "${var.storage_os_disk_managed_disk_type}"
  storage_os_disk_disk_size_gb      = "${var.storage_os_disk_disk_size_gb}"

  custom_vm_name     = "${var.custom_vm_name}"
  custom_vm_hostname = "${var.custom_vm_hostname}"
  custom_disk_name   = "${var.custom_disk_name}"
  custom_username    = "${var.custom_username}"

  bastion_extra_tags = "${var.bastion_extra_tags}"
  ani_extra_tags     = "${var.ani_extra_tags}"
  pubip_extra_tags   = "${var.pubip_extra_tags}"
}
