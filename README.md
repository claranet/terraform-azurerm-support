# Azure - Claranet Support stack

Claranet Azure feature support.

## Prerequisites

- SSH Key file should be: ~/.ssh/keys/${var.client_name}_${var.environment}.pem

## Mandatory Usage

```shell
module "azure-region" {
    source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

    azure_region = "${var.azure_region}"
}

module "rg" {
    source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

    location     = "${module.azure-region.location}"
    client_name  = "${var.client_name}"
    environment  = "${var.environment}"
    stack        = "${var.stack}"
}

module "vnet" {
    source              = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vnet.git?ref=xxx"
    
    environment         = "${var.environment}"
    location            = "${module.azure-region.location}"
    location-short      = "${module.azure-region.location-short}"
    client_name         = "${var.client_name}"
    stack               = "${var.stack}"
    custom_vnet_name    = "${var.custom_vnet_name}"

    resource_group_name     = "${module.rg.resource_group_name}"
    vnet_cidr               = ["${var.vnet_cidr}"]
}


module "support" {
    source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/support.git?ref=vX.X.X"

    client_name             = "${var.client_name}"
    location                = "${module.azure-region.location}"
    location-short          = "${module.azure-region.location-short}"
    environment             = "${var.environment}"
    stack                   = "${var.stack}"
    resource_group_name     = "${module.rg.resource_group_name}"

    admin_ssh_ips           = "${join(",",var.admin_ssh_ips_list)}"
    nsg-name                = "${var.define-nsg-name}"

    virtual_network_name    = ${module.vnet.virtual_network_name}
    # Define your subnet_cidr if you want to overide it
    subnet_cidr             = ["x.x.x.x/x"]

    vm_size                 = "${var.vm_size}"
    # Define your private ip bastion if you want to overide it
    private_ip_bastion      = "${var.private_ip_bastion}"
    support_dns_zone_name   = "${var.support_dns_zone_name}"
    
    ssh_key_pub             = "~/.ssh/key/${var.client_name}_${var.environment}.pem"
}

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin_ssh_ips | Claranet IPs allowed to use SSH on bastion | string | - | yes |
| client_name | Client name/account used in naming | string | - | yes |
| custom_disk_name | Bastion disk name as displayed in the console | string | `` | no |
| custom_username | Default username to create on the bastion | string | `` | no |
| custom_vm_hostname | Bastion hostname | string | `` | no |
| custom_vm_name | VM Name as displayed on the console | string | `` | no |
| delete_os_disk_on_termination | Enable delete disk on termination | string | `true` | no |
| environment | Project environment | string | - | yes |
| extra_tags | Additional tags to associate with your network security group. | map | `<map>` | no |
| location | Azure region to use | string | - | yes |
| location-short | Short string for Azure location | string | - | yes |
| nsg-name | Name used for nsg naming | string | `test` | no |
| private_ip_bastion | Allows to define the private ip to associate with the bastion | string | `10.10.1.10` | no |
| resource_group_name | Name of the resource group | string | - | yes |
| route_table_ids | The Route Table Ids list to associate with the subnet | list | `<list>` | no |
| service_endpoints | The list of Service endpoints to associate with the subnet | list | `<list>` | no |
| ssh_key_pub | Name of the SSH key pub to use | string | - | yes |
| stack | Project stack name | string | - | yes |
| subnet_cidr | The address prefix list to use for the subnet | list | `10.10.1.0/24` | no |
| virtual_network_name | Virtual network name | string | - | yes |
| vm_size | Bastion virtual machine size | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion_network_interface_id | Bastion network interface id |
| bastion_network_interface_private_ip | Bastion private ip |
| bastion_network_public_ip | Bastion public ip |
| bastion_network_public_ip_id | Bastion public ip id |
| bastion_virtual_machine_id | Bastion virtual machine id |
| network_security_group_id | Network security group id |
| network_security_group_name | Network security group name |
| subnet_cidr | CIDR list of the created subnets |
| subnet_id | Ids of the created subnets |
| subnet_ip_configurations | The collection of IP Configurations with IPs within this subnet |
| subnet_name | Names list of the created subnet |