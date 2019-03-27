# Azure - Claranet Support stack

Azure Support stack. It deploys subnet, NSG, and bastion instance.

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
    
    ssh_key_pub             = "~/.ssh/keys/${var.client_name}_${var.environment}.pem.pub"
    private_key_path	    = "~/.ssh/keys/${var.client_name}_${var.environment}.pem"
}

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin\_ssh\_ips | Claranet IPs allowed to use SSH on bastion | string | n/a | yes |
| ani\_extra\_tags | Additional tags to associate with your network interface. | map | `<map>` | no |
| bastion-name | Name used for bastion naming | string | n/a | yes |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | map | `<map>` | no |
| client\_name | Client name/account used in naming | string | n/a | yes |
| custom\_disk\_name | Bastion disk name as displayed in the console | string | `""` | no |
| custom\_username | Default username to create on the bastion | string | `""` | no |
| custom\_vm\_hostname | Bastion hostname | string | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | string | `""` | no |
| delete\_os\_disk\_on\_termination | Enable delete disk on termination | string | `"true"` | no |
| environment | Project environment | string | n/a | yes |
| extra\_tags | Additional tags to associate with your network security group. | map | `<map>` | no |
| location | Azure region to use | string | n/a | yes |
| location-short | Short string for Azure location | string | n/a | yes |
| nsg-name | Name used for nsg naming | string | n/a | yes |
| private\_ip\_bastion | Allows to define the private ip to associate with the bastion | string | `"10.10.1.10"` | no |
| private\_key\_path | Path to the private SSH key to use | string | n/a | yes |
| pubip\_extra\_tags | Additional tags to associate with your public ip. | map | `<map>` | no |
| resource\_group\_name | Name of the resource group | string | n/a | yes |
| route\_table\_ids | The Route Table Ids list to associate with the subnet | list | `<list>` | no |
| service\_endpoints | The list of Service endpoints to associate with the subnet | list | `<list>` | no |
| ssh\_key\_pub | Name of the SSH key pub to use | string | n/a | yes |
| stack | Project stack name | string | n/a | yes |
| storage\_image\_offer | Specifies the offer of the image used to create the virtual machine | string | `"UbuntuServer"` | no |
| storage\_image\_publisher | Specifies the publisher of the image used to create the virtual machine | string | `"Canonical"` | no |
| storage\_image\_sku | Specifies the SKU of the image used to create the virtual machine | string | `"18.04-LTS"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk | string | `"ReadWrite"` | no |
| storage\_os\_disk\_create\_option | Specifies how the OS disk shoulb be created | string | `"FromImage"` | no |
| storage\_os\_disk\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes | string | n/a | yes |
| storage\_os\_disk\_managed\_disk\_type | Specifies the type of Managed Disk which should be created [Standard_LRS, StandardSSD_LRS, Premium_LRS] | string | `"Standard_LRS"` | no |
| subnet\_cidr | The address prefix list to use for the subnet | list | `<list>` | no |
| virtual\_network\_name | Virtual network name | string | n/a | yes |
| vm\_size | Bastion virtual machine size | string | n/a | yes |

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
| subnet_ids | Ids of the created subnets |
| subnet_ip_configurations | The collection of IP Configurations with IPs within this subnet |
| subnet_names | Names list of the created subnet |
