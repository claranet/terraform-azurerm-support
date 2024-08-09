# Azure - Claranet Support stack
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/support/azurerm/)

Azure Support module. It creates a subnet, a Network Security Group and a bastion VM instance from a Claranet image by default.
Included module documentation:
  * [Subnet](https://registry.terraform.io/modules/claranet/subnet/azurerm/latest)
  * [NSG](https://registry.terraform.io/modules/claranet/nsg/azurerm/latest)
  * [claranet-gallery-images](https://registry.terraform.io/modules/claranet/claranet-gallery-images/azapi/latest)
  * [linux-vm](https://registry.terraform.io/modules/claranet/linux-vm/azurerm/latest)

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

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

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  monitoring_function_enabled = false
  vm_monitoring_enabled       = true
  backup_vm_enabled           = true
  update_center_enabled       = false

  recovery_vault_cross_region_restore_enabled = true
  vm_backup_daily_policy_retention            = 31
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

  # Bastion parameters
  vm_size                 = "Standard_B1s"
  storage_os_disk_size_gb = "32"

  admin_ssh_ips = var.admin_ssh_ips

  # Define your private ip bastion if you want to override it
  bastion_private_ip = "10.10.10.10"

  # Set to null to deactivate backup (not recommended)
  bastion_backup_policy_id = module.run.vm_backup_policy_id

  # Optional: Put your SSH key here
  ssh_public_key = tls_private_key.bastion.public_key_openssh

  # Define your subnets if you want to override it
  subnet_cidr_list = ["10.10.10.0/24"]
  #  support_dns_zone_name = var.support_dns_zone_name

  # Diagnostics / logs
  diagnostics_storage_account_name      = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule_id = module.run.data_collection_rule_id
  log_analytics_workspace_guid          = module.run.log_analytics_workspace_guid
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.108 |
| tls | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| azure\_region | claranet/regions/azurerm | ~> 7.1.0 |
| bastion\_vm | claranet/linux-vm/azurerm | ~> 7.11.2 |
| claranet\_gallery\_images | claranet/claranet-gallery-images/azapi | ~> 7.0.0 |
| support\_nsg | claranet/nsg/azurerm | ~> 7.7.0 |
| support\_subnet | claranet/subnet/azurerm | ~> 7.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet_network_security_group_association.subnet_bastion_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_ssh\_login\_admin\_objects\_ids | Azure Active Directory objects IDs allowed to connect as administrator on the VM. | `list(string)` | `[]` | no |
| aad\_ssh\_login\_enabled | Enable SSH logins with Azure Active Directory. | `bool` | `false` | no |
| aad\_ssh\_login\_extension\_version | VM Extension version for Azure Active Directory SSH Login extension. | `string` | `"1.0"` | no |
| aad\_ssh\_login\_user\_objects\_ids | Azure Active Directory objects IDs allowed to connect as standard user on the VM. | `list(string)` | `[]` | no |
| admin\_password | Password for the administrator account of the virtual machine. | `string` | `null` | no |
| admin\_ssh\_ips | Claranet IPs allowed to use SSH on bastion. | `list(string)` | n/a | yes |
| admin\_username | Name of the administrator user. | `string` | `"claranet"` | no |
| azure\_monitor\_agent\_auto\_upgrade\_enabled | Automatically update agent when publisher releases a new version of the agent. | `bool` | `false` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version. | `string` | `"1.12"` | no |
| azure\_monitor\_data\_collection\_rule\_id | Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` if legacy agent is used. | `string` | n/a | yes |
| bastion\_backup\_policy\_id | Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup). | `string` | n/a | yes |
| bastion\_custom\_data | The Base64-Encoded Custom Data which should be used for the bastion. Changing this forces a new resource to be created. | `string` | `null` | no |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | `map(string)` | `{}` | no |
| bastion\_identity | Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| bastion\_maintenance\_configuration\_ids | List of maintenance configurations to attach to this VM. | `list(string)` | `[]` | no |
| bastion\_nic\_accelerated\_networking\_enabled | Should Accelerated Networking be enabled? Defaults to false. | `bool` | `false` | no |
| bastion\_patch\_mode | Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault` | `string` | `"ImageDefault"` | no |
| bastion\_private\_ip | Allows to define the private IP to associate with the bastion. | `string` | `null` | no |
| bastion\_public\_ip\_sku | Public IP SKU attached to the bastion VM. Can be `null` if no public IP is needed.<br>If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private IP.<br>Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory. | `string` | `"Standard"` | no |
| bastion\_public\_ip\_zones | Zones for public IP attached to the VM. Can be `null` if no zone distpatch. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| bastion\_user\_data | The Base64-Encoded User Data which should be used for the bastion. | `string` | `null` | no |
| bastion\_vm\_image | Bastion Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined. Defaults to Claranet image. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | `null` | no |
| bastion\_vm\_image\_id | The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null. Defaults to Claranet image. | `string` | `null` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_bastion\_dns\_label | Custom name for DNS label. | `string` | `null` | no |
| custom\_bastion\_ipconfig\_name | Custom name for IP Configuration. | `string` | `null` | no |
| custom\_bastion\_nic\_name | Custom name for NIC. | `string` | `null` | no |
| custom\_bastion\_public\_ip\_name | Custom name for public IP. | `string` | `null` | no |
| custom\_bastion\_storage\_os\_disk\_name | Custom name for Bastion OS disk. | `string` | `""` | no |
| custom\_bastion\_vm\_hostname | Custom Bastion hostname. | `string` | `""` | no |
| custom\_bastion\_vm\_name | VM Name as displayed on the console. | `string` | `""` | no |
| custom\_security\_group\_name | Custom name for Network Security Group. | `string` | `null` | no |
| custom\_subnet\_name | Custom name for Subnet. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store VM diagnostics. | `string` | n/a | yes |
| environment | Project environment. | `string` | n/a | yes |
| extensions\_extra\_tags | Extra tags to set on the VM extensions. | `map(string)` | `{}` | no |
| flow\_log\_enabled | Provision network watcher flow logs. | `bool` | `false` | no |
| flow\_log\_location | The location where the Network Watcher Flow Log resides. Changing this forces a new resource to be created. Defaults to the `location` of the Network Watcher. | `string` | `null` | no |
| flow\_log\_logging\_enabled | Enable Network Flow Logging. | `bool` | `true` | no |
| flow\_log\_retention\_policy\_days | The number of days to retain flow log records. | `number` | `31` | no |
| flow\_log\_retention\_policy\_enabled | Boolean flag to enable/disable retention. | `bool` | `true` | no |
| flow\_log\_storage\_account\_id | Network watcher flow log storage account ID. | `string` | `null` | no |
| flow\_log\_traffic\_analytics\_enabled | Boolean flag to enable/disable traffic analytics. | `bool` | `true` | no |
| flow\_log\_traffic\_analytics\_interval\_in\_minutes | How frequently service should do flow analytics in minutes. | `number` | `10` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_guid | The resource GUID of the attached workspace. | `string` | `null` | no |
| log\_analytics\_workspace\_id | The resource ID of the attached workspace. | `string` | `null` | no |
| log\_analytics\_workspace\_location | The location of the attached workspace. | `string` | `null` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `"bastion"` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| network\_watcher\_name | The name of the Network Watcher. Changing this forces a new resource to be created. | `string` | `null` | no |
| network\_watcher\_resource\_group\_name | The name of the resource group in which the Network Watcher was deployed. Changing this forces a new resource to be created. | `string` | `null` | no |
| nic\_extra\_tags | Additional tags to associate with your network interface. | `map(string)` | `{}` | no |
| nsg\_additional\_rules | Additional network security group rules to add. For arguments please refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule#argument-reference. | <pre>list(object({<br>    priority  = number<br>    name      = string<br>    direction = optional(string)<br>    access    = optional(string)<br>    protocol  = optional(string)<br><br>    source_port_range  = optional(string)<br>    source_port_ranges = optional(list(string))<br><br>    destination_port_range  = optional(string)<br>    destination_port_ranges = optional(list(string))<br><br>    source_address_prefix   = optional(string)<br>    source_address_prefixes = optional(list(string))<br><br>    destination_address_prefix   = optional(string)<br>    destination_address_prefixes = optional(list(string))<br>  }))</pre> | `[]` | no |
| nsg\_extra\_tags | Additional tags to associate with your Network Security Group. | `map(string)` | `{}` | no |
| private\_link\_endpoint\_enabled | Enable or disable network policies for the Private Endpoint on the subnet. | `bool` | `null` | no |
| private\_link\_service\_enabled | Enable or disable network policies for the Private Link Service on the subnet. | `bool` | `null` | no |
| public\_ip\_extra\_tags | Additional tags to associate with your public IP. | `map(string)` | `{}` | no |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| route\_table\_name | The Route Table name to associate with the subnet. | `string` | `null` | no |
| route\_table\_rg | The Route Table RG to associate with the subnet. Default is the same RG than the subnet. | `string` | `null` | no |
| service\_endpoint\_policy\_ids | The list of IDs of Service Endpoint Policies to associate with the subnet. | `list(string)` | `null` | no |
| service\_endpoints | The list of Service endpoints to associate with the subnet. | `list(string)` | `[]` | no |
| ssh\_public\_key | SSH public key, generated if empty. | `string` | `null` | no |
| stack | Project stack name. | `string` | n/a | yes |
| storage\_os\_disk\_account\_type | The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. | `string` | `"Premium_ZRS"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk. | `string` | `"ReadWrite"` | no |
| storage\_os\_disk\_extra\_tags | Additional tags to set on the OS disk. | `map(string)` | `{}` | no |
| storage\_os\_disk\_overwrite\_tags | True to overwrite existing OS disk tags instead of merging. | `bool` | `false` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes. | `string` | n/a | yes |
| storage\_os\_disk\_tagging\_enabled | Should OS disk tagging be enabled? Defaults to `true`. | `bool` | `true` | no |
| subnet\_cidr\_list | The address prefixes to use for the subnet. | `list(string)` | n/a | yes |
| virtual\_network\_name | Bastion VM virtual network name. | `string` | n/a | yes |
| virtual\_network\_resource\_group\_name | Bastion VM virtual network resource group name, default to `resource_group_name` if empty. | `string` | `""` | no |
| vm\_size | Bastion virtual machine size. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_admin\_password | Password of the admin user. |
| bastion\_admin\_username | Username of the admin user. |
| bastion\_hostname | Bastion hostname. |
| bastion\_maintenance\_configurations\_assignments | Maintenance configurations assignments configurations. |
| bastion\_network\_interface\_id | Bastion network interface ID. |
| bastion\_network\_interface\_private\_ip | Bastion private IP. |
| bastion\_network\_public\_ip | Bastion public IP. |
| bastion\_network\_public\_ip\_id | Bastion public IP ID. |
| bastion\_public\_domain\_name\_label | Bastion public DNS. |
| bastion\_ssh\_private\_key | Bastion SSH private key. |
| bastion\_ssh\_public\_key | Bastion SSH public key. |
| bastion\_virtual\_machine\_id | Bastion virtual machine ID. |
| bastion\_virtual\_machine\_identity | System Identity assigned to the bastion virtual machine. |
| bastion\_virtual\_machine\_name | Bastion virtual machine name. |
| bastion\_virtual\_machine\_os\_disk | Bastion virtual machine OS disk object. |
| network\_security\_group\_id | Network security group ID. |
| network\_security\_group\_name | Network security group name. |
| subnet\_cidr\_list | CIDR list of the created subnet. |
| subnet\_id | ID of the created subnet. |
| subnet\_name | Name of the created subnet. |
| terraform\_module | Information about this Terraform module. |
<!-- END_TF_DOCS -->
