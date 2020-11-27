# Azure - Claranet Support stack

Azure Support stack for Claranet. It creates a subnet, a Network Security Group and a bastion VM instance.

## Version compatibility

| Module version | Terraform version | AzureRM version |
|----------------|-------------------| --------------- |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure-network-vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"
    
  environment      = var.environment
  location         = module.azure-region.location
  location_short   = module.azure-region.location_short
  client_name      = var.client_name
  stack            = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

locals {
  subnet_cidr = "10.10.10.0/24"

  public_ssh_key_path  = "~/.ssh/keys/${var.client_name}_${var.environment}_${var.stack}.pub"
  private_ssh_key_path = "~/.ssh/keys/${var.client_name}_${var.environment}_${var.stack}.pem"

  bastion_private_ip = "10.10.10.10"
  bastion_disk_size  = "32"
  bastion_vm_size    = "Standard_B1s"
}

module "support" {
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/module/support.git?ref=vX.X.X"

  client_name         = var.client_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure-network-vnet.virtual_network_name

  # bastion parameters
  vm_size                 = local.bastion_vm_size
  storage_os_disk_size_gb = local.bastion_disk_size

  admin_ssh_ips = concat(
    data.terraform_remote_state.global_vars.outputs.admin_cidrs,
    local.external_admin_ips
  )

  # Define your private ip bastion if you want to override it
  private_ip_bastion = local.bastion_private_ip
  ssh_key_pub        = local.public_ssh_key_path
  private_key_path   = local.private_ssh_key_path

  # Define your subnet_cidr if you want to override it
  subnet_cidr = local.subnet_cidr
  #  support_dns_zone_name = var.support_dns_zone_name

  diagnostics_storage_account_name      = module.run-common.logs_storage_account_name
  diagnostics_storage_account_sas_token = module.run-common.logs_storage_account_sas_token["sastoken"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_ssh\_ips | Claranet IPs allowed to use SSH on bastion | `list(string)` | n/a | yes |
| admin\_username | Name of the admin user | `string` | `"claranet"` | no |
| ani\_extra\_tags | Additional tags to associate with your network interface. | `map(string)` | `{}` | no |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | `map(string)` | `{}` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_bastion\_subnet\_name | Custom name for bastion subnet | `string` | `null` | no |
| custom\_disk\_name | Bastion disk name as displayed in the console | `string` | `""` | no |
| custom\_ipconfig\_name | Custom name for IP Configuration | `string` | `null` | no |
| custom\_nic\_name | Custom name fir NIC | `string` | `null` | no |
| custom\_publicip\_name | Custom name for public IP | `string` | `null` | no |
| custom\_security\_group\_name | Custom name for network security group | `string` | `null` | no |
| custom\_vm\_hostname | Bastion hostname | `string` | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | `string` | `""` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | SAS token of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Additional tags to associate with your network security group. | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for resources naming | `string` | `"bastion-"` | no |
| private\_ip\_bastion | Allows to define the private ip to associate with the bastion | `string` | `"10.10.1.10"` | no |
| private\_key\_path | Root SSH private key path | `string` | n/a | yes |
| pubip\_extra\_tags | Additional tags to associate with your public ip. | `map(string)` | `{}` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| route\_table\_ids | The Route Table Ids list to associate with the subnet | `map(string)` | `{}` | no |
| service\_endpoints | The list of Service endpoints to associate with the subnet | `list(string)` | `[]` | no |
| ssh\_key\_pub | Name of the SSH key pub to use | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| storage\_image\_offer | Specifies the offer of the image used to create the virtual machine | `string` | `"UbuntuServer"` | no |
| storage\_image\_publisher | Specifies the publisher of the image used to create the virtual machine | `string` | `"Canonical"` | no |
| storage\_image\_sku | Specifies the SKU of the image used to create the virtual machine | `string` | `"18.04-LTS"` | no |
| storage\_image\_version | Specifies the version of the image used to create the virtual machine | `string` | `"latest"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk | `string` | `"ReadWrite"` | no |
| storage\_os\_disk\_managed\_disk\_type | Specifies the type of Managed Disk which should be created [Standard\_LRS, StandardSSD\_LRS, Premium\_LRS] | `string` | `"Standard_LRS"` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes | `string` | n/a | yes |
| subnet\_cidr | The address prefix to use for the subnet | `string` | `"10.10.1.0/24"` | no |
| virtual\_network\_name | Virtual network name | `string` | n/a | yes |
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
| bastion\_virtual\_machine\_id | Bastion virtual machine id |
| bastion\_virtual\_machine\_name | Bastion virtual machine name |
| bastion\_virtual\_machine\_size | Bastion virtual machine size |
| network\_security\_group\_id | Network security group id |
| network\_security\_group\_name | Network security group name |
| subnet\_cidr\_list | CIDR list of the created subnets |
| subnet\_ids | Ids of the created subnets |
| subnet\_names | Names list of the created subnet |

