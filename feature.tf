module "support-subnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=AZ-5-az-subnet"

  environment    = "${var.environment}"
  location-short = "${var.location-short}"
  client_name    = "${var.client_name}"
  stack          = "${var.stack}"

  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  subnet_cidr          = "${var.subnet_cidr}"

  route_table_id            = "${var.route_table_ids}"
  service_endpoints         = "${var.service_endpoints}"
  network_security_group_id = "${var.network_security_group_ids}"
}

module "support-network-security-group" {
  source              = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/nsg.git?ref=AZ-5_Add_nsg_module"
  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  location_short      = "${var.location_short}"
  name                = "${var.nsg-name}"

  custom_rules = [
    {
      name                       = "SSH"
      priority                   = "500"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      destination_port_range     = "22"
      source_address_prefix      = "${var.admin_ssh_ips}"
      destination_address_prefix = "${module.bastion.bastion_network_interface_private_ip}"
      description                = "Allow Admin Claranet SSH Bastion"
    },
  ]
}

resource "azurerm_subnet_network_security_group_association" "subnet-with-nsg-support" {
  subnet_id                 = "${module.support-subnet.subnet_id}"
  network_security_group_id = "${module.support-network-security-group.network_security_group_id}"
}

module "bastion" {
  source = "git@git.fr.clara.net:claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion.git?ref=AZ-11-update-bastion-module"

  client_name         = "${var.client_name}"
  location            = "${var.location}"
  location-short      = "${var.location-short}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"

  network_security_group_id = "${module.support-network-security-group.network_security_group_id}"
  subnet_bastion_id         = "${module.support-subnet.subnet_id}"
  private_ip_bastion        = "${var.private_ip_bastion}"

  vm_size = "${var.vm_size}"

  # Put your SSK Public Key here
  ssh_key_pub = "${file("./put_the_key_here.pub")}"

  support_dns_zone_name = "${var.support_dns_zone_name}"

  custom_vm_name     = "${var.custom_vm_name}"
  custom_vm_hostname = "${var.custom_vm_hostname}"
  custom_disk_name   = "${var.custom_disk_name}"
  custom_username    = "${var.custom_username}"

  extra_tags = "${var.extra_tags}"
}
