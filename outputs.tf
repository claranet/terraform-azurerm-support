module "azure-network-subnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=AZ-5-az-subnet"

  environment        = "${var.environment}"
  location-short     = "${module.azure-region.location-short}"
  client_name        = "${var.client_name}"
  stack              = "${var.stack}"
  custom_subnet_name = "${var.custom_subnet_name}"

  resource_group_name  = "${module.rg.resource_group_name}"
  virtual_network_name = "${module.vnet.virtual_network_name}"
  subnet_cidr          = "${var.subnet_cidr}"
}

module "network-security-group" {
  source              = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/nsg.git?ref=xxx"
  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  location_short      = "${var.location_short}"
  name                = "${var.network-security-group-name}"

  predefined_rules = [
    {
      name                  = "SSH"
      priority              = "500"
      source_address_prefix = "10.0.3.0/24"
    },
  ]
}

resource "azurerm_subnet_network_security_group_association" "subnet-with-nsg-support" {
  subnet_id                 = "${module.azure-network-subnet.subnet_id}"
  network_security_group_id = "${module.network-security-group.network_security_group_id}"
}
