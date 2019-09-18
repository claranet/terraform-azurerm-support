# Azure - Claranet Support stack

Azure Support stack for Claranet. It creates a subnet, a Network Security Group and a bastion instance.

# Requirements
* Azure provider >= 1.31
* Terraform >=0.12

## Prerequisites

* SSH Key file should be: ~/.ssh/keys/${var.client_name}_${var.environment}.pem

## Usage

```hcl
module "az-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = var.azure_region
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location    = module.az-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure-network-vnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vnet.git?ref=vX.X.X"
    
  environment      = var.environment
  location         = module.azure-region.location
  location_short   = module.azure-region.location_short
  client_name      = var.client_name
  stack            = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}


module "support" {
    source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/support.git?ref=vX.X.X"

    client_name         = var.client_name
    location            = module.azure-region.location
    location_short      = module.azure-region.location_short
    environment         = var.environment
    stack               = var.stack
    resource_group_name = module.rg.resource_group_name

    admin_ssh_ips = var.admin_ssh_ips_list
    name_prefix   = var.name_prefix

    virtual_network_name = module.vnet.virtual_network_name
    # Define your subnet_cidr if you want to override it
    subnet_cidr          = ["10.0.0.0/24"]

    vm_size               = var.vm_size
    # Define your private ip bastion if you want to override it
    private_ip_bastion    = var.private_ip_bastion
    support_dns_zone_name = var.support_dns_zone_name
    
    ssh_key_pub      = "~/.ssh/keys/${var.client_name}_${var.environment}.pem.pub"
    private_key_path = "~/.ssh/keys/${var.client_name}_${var.environment}.pem"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin\_ssh\_ips | Claranet IPs allowed to use SSH on bastion | list(string) | n/a | yes |
| ani\_extra\_tags | Additional tags to associate with your network interface. | map(string) | `<map>` | no |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | map(string) | `<map>` | no |
| client\_name | Client name/account used in naming | string | n/a | yes |
| custom\_disk\_name | Bastion disk name as displayed in the console | string | `""` | no |
| custom\_username | Default username to create on the bastion | string | `""` | no |
| custom\_vm\_hostname | Bastion hostname | string | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | string | `""` | no |
| delete\_os\_disk\_on\_termination | Enable delete disk on termination | string | `"true"` | no |
| environment | Project environment | string | n/a | yes |
| extra\_tags | Additional tags to associate with your network security group. | map(string) | `<map>` | no |
| location | Azure region to use | string | n/a | yes |
| location\_short | Short string for Azure location | string | n/a | yes |
| name\_prefix | Prefix used for resources naming | string | `""` | no |
| private\_ip\_bastion | Allows to define the private ip to associate with the bastion | string | `"10.10.1.10"` | no |
| private\_key\_path | Path to the private SSH key to use | string | n/a | yes |
| pubip\_extra\_tags | Additional tags to associate with your public ip. | map(string) | `<map>` | no |
| resource\_group\_name | Name of the resource group | string | n/a | yes |
| route\_table\_count | Count of Route Table to associate with the subnet | string | `"0"` | no |
| route\_table\_ids | The Route Table Ids list to associate with the subnet | list(string) | `<list>` | no |
| service\_endpoints | The list of Service endpoints to associate with the subnet | list(string) | `<list>` | no |
| ssh\_key\_pub | Name of the SSH key pub to use | string | n/a | yes |
| stack | Project stack name | string | n/a | yes |
| storage\_image\_offer | Specifies the offer of the image used to create the virtual machine | string | `"UbuntuServer"` | no |
| storage\_image\_publisher | Specifies the publisher of the image used to create the virtual machine | string | `"Canonical"` | no |
| storage\_image\_sku | Specifies the SKU of the image used to create the virtual machine | string | `"18.04-LTS"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk | string | `"ReadWrite"` | no |
| storage\_os\_disk\_create\_option | Specifies how the OS disk shoulb be created | string | `"FromImage"` | no |
| storage\_os\_disk\_managed\_disk\_type | Specifies the type of Managed Disk which should be created [Standard_LRS, StandardSSD_LRS, Premium_LRS] | string | `"Standard_LRS"` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes | string | n/a | yes |
| subnet\_cidr | The address prefix to use for the subnet | string | `"10.10.1.0/24"` | no |
| virtual\_network\_name | Virtual network name | string | n/a | yes |
| vm\_size | Bastion virtual machine size | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_network\_interface\_id | Bastion network interface id |
| bastion\_network\_interface\_private\_ip | Bastion private ip |
| bastion\_network\_public\_ip | Bastion public ip |
| bastion\_network\_public\_ip\_id | Bastion public ip id |
| bastion\_virtual\_machine\_id | Bastion virtual machine id |
| bastion\_virtual\_machine\_name | Bastion virtual machine name |
| network\_security\_group\_id | Network security group id |
| network\_security\_group\_name | Network security group name |
| subnet\_cidr\_list | CIDR list of the created subnets |
| subnet\_ids | Ids of the created subnets |
| subnet\_ip\_configurations | The collection of IP Configurations with IPs within this subnet |
| subnet\_names | Names list of the created subnet |
