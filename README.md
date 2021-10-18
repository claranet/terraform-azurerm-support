# Azure - Claranet Support stack

Azure Support stack for Claranet. It creates a subnet, a Network Security Group and a bastion VM instance.
Included module documentation:
  * [Subnet](https://registry.terraform.io/modules/claranet/subnet/azurerm/latest)
  * [NSG](https://registry.terraform.io/modules/claranet/nsg/azurerm/latest)
  * [bastion-vm](https://github.com/claranet/terraform-azurerm-bastion-vm/blob/master/README.md)
    * [linux-vm](https://registry.terraform.io/modules/claranet/linux-vm/azurerm/latest)

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

module "support" {
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/module/support.git?ref=vX.X.X"

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure_network_vnet.virtual_network_name

  # bastion parameters
  vm_size                 = "Standard_B1s"
  storage_os_disk_size_gb = "32"

  admin_ssh_ips = var.admin_ssh_ips

  # Define your private ip bastion if you want to override it
  private_ip_bastion = "10.10.10.10"

  # Optional: Put your SSH key here
  ssh_public_key  = tls_private_key.bastion.public_key_openssh
  ssh_private_key = tls_private_key.bastion.private_key_pem

  # Define your subnets if you want to override it
  subnet_cidr_list = ["10.10.10.0/24"]
  #  support_dns_zone_name = var.support_dns_zone_name

  diagnostics_storage_account_name      = module.logs.logs_storage_account_name
  diagnostics_storage_account_sas_token = module.logs.logs_storage_account_sas_token
}

```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.8 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| bastion | github.com/claranet/terraform-azurerm-bastion-vm.git | v4.3.0 |
| support\_nsg | claranet/nsg/azurerm | 4.1.1 |
| support\_subnet | claranet/subnet/azurerm | 4.2.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_rule.ssh_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet_network_security_group_association.subnet_bastion_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_ssh\_ips | Claranet IPs allowed to use SSH on bastion | `list(string)` | n/a | yes |
| admin\_username | Name of the admin user | `string` | `"claranet"` | no |
| ani\_extra\_tags | Additional tags to associate with your network interface. | `map(string)` | `{}` | no |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | `map(string)` | `{}` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_bastion\_subnet\_name | Custom name for bastion subnet | `string` | `null` | no |
| custom\_ipconfig\_name | Custom name for IP Configuration | `string` | `null` | no |
| custom\_nic\_name | Custom name fir NIC | `string` | `null` | no |
| custom\_public\_ip\_name | Custom name for public IP | `string` | `null` | no |
| custom\_security\_group\_name | Custom name for network security group | `string` | `null` | no |
| custom\_vm\_hostname | Bastion hostname | `string` | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | `string` | `""` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | SAS token of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for resources naming | `string` | `"bastion-"` | no |
| nsg\_extra\_tags | Additional tags to associate with your Network Security Group. | `map(string)` | `{}` | no |
| private\_ip\_bastion | Allows to define the private ip to associate with the bastion | `string` | `"10.10.1.10"` | no |
| pubip\_extra\_tags | Additional tags to associate with your public ip. | `map(string)` | `{}` | no |
| public\_ip\_sku | Public IP SKU attached to the bastion VM. Can be `null` if no public IP is needed.<br>If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private ip. <br>Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory. | `string` | `"Standard"` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| route\_table\_name | The Route Table name to associate with the subnet | `string` | `null` | no |
| route\_table\_rg | The Route Table RG to associate with the subnet. Default is the same RG than the subnet. | `string` | `null` | no |
| service\_endpoints | The list of Service endpoints to associate with the support subnet | `list(string)` | `[]` | no |
| ssh\_private\_key | SSH private key, generated if empty | `string` | `""` | no |
| ssh\_public\_key | SSH public key, generated if empty | `string` | `""` | no |
| stack | Project stack name | `string` | n/a | yes |
| storage\_image\_offer | Specifies the offer of the image used to create the virtual machine | `string` | `"UbuntuServer"` | no |
| storage\_image\_publisher | Specifies the publisher of the image used to create the virtual machine | `string` | `"Canonical"` | no |
| storage\_image\_sku | Specifies the SKU of the image used to create the virtual machine | `string` | `"18.04-LTS"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk | `string` | `"ReadWrite"` | no |
| storage\_os\_disk\_custom\_name | Bastion OS disk name as displayed in the console | `string` | `""` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes | `string` | n/a | yes |
| subnet\_cidr\_list | The address prefixes to use for the subnet | `list(string)` | <pre>[<br>  "10.10.1.0/24"<br>]</pre> | no |
| virtual\_network\_name | Virtual network name | `string` | n/a | yes |
| virtual\_network\_resource\_group\_name | Virtual network resource group name, default to `resource_group_name` if empty | `string` | `""` | no |
| vm\_size | Bastion virtual machine size | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_admin\_username | Username of the admin user |
| bastion\_hostname | Bastion hostname |
| bastion\_network\_interface\_id | Bastion network interface id |
| bastion\_network\_interface\_private\_ip | Bastion private ip |
| bastion\_network\_public\_ip | Bastion public ip |
| bastion\_network\_public\_ip\_id | Bastion public ip id |
| bastion\_public\_domain\_name\_label | Bastion public DNS |
| bastion\_ssh\_private\_key | Bastion SSH private key |
| bastion\_ssh\_public\_key | Bastion SSH public key |
| bastion\_virtual\_machine\_id | Bastion virtual machine id |
| bastion\_virtual\_machine\_identity | System Identity assigned to Bastion virtual machine |
| bastion\_virtual\_machine\_name | Bastion virtual machine name |
| bastion\_virtual\_machine\_size | Bastion virtual machine size |
| network\_security\_group\_id | Network security group id |
| network\_security\_group\_name | Network security group name |
| subnet\_cidr\_list | CIDR list of the created subnet |
| subnet\_id | ID of the created subnet |
| subnet\_name | Name of the created subnet |
<!-- END_TF_DOCS -->
