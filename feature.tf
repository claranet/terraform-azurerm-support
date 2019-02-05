module "support-subnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=AZ-5-az-subnet"

  environment    = "${var.environment}"
  location-short = "${var.location-short}"
  client_name    = "${var.client_name}"
  stack          = "${var.stack}"

  resource_group_name  = "${module.rg.resource_group_name}"
  virtual_network_name = "${module.vnet.virtual_network_name}"
  subnet_cidr          = "${var.subnet_cidr}"
}

module "support-network-security-group" {
  source              = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/nsg.git?ref=xxx"
  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  location_short      = "${var.location_short}"
  name                = "${var.nsg-name}"

  # Must be completed with bastion rules
  # https://git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion/blob/master/network/rules.tf
  predefined_rules = [
    {
      name                  = "SSH"
      priority              = "500"
      source_address_prefix = "10.0.3.0/24"
    },
  ]
}

resource "azurerm_subnet_network_security_group_association" "subnet-with-nsg-support" {
  subnet_id                 = "${module.support-subnet.subnet_id}"
  network_security_group_id = "${module.support-network-security-group.network_security_group_id}"
}

module "bastion" {
  # Must be redifined
  source = "git@git.fr.clara.net:claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion.git"

  client_name    = "${var.client_name}"
  azurerm_region = "${var.location}"
  environment    = "${var.environment}"

  support_resourcegroup_name = "${var.resource_group_name}"
  support_dns_zone_name      = "${module.dns.dns_zone_name}"

  subnet_bastion_id = "${module.support-subnet.subnet_id}"

  vm_size = "${var.vm_size}"

  # Put your SSK Public Key here
  ssh_key_pub = "${file("./put_the_key_here.pub")}"
}
