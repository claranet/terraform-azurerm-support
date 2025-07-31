# Azure - Claranet Support stack
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/support/azurerm/)

Azure Support module. It creates a subnet, a Network Security Group and a bastion VM instance from a Claranet image by default.
Included module documentation:
  * [Subnet](https://search.opentofu.org/module/claranet/subnet/azurerm/latest)
  * [NSG](https://search.opentofu.org/module/claranet/nsg/azurerm/latest)
  * [claranet-gallery-images](https://search.opentofu.org/module/claranet/claranet-gallery-images/azapi/latest)
  * [linux-vm](https://search.opentofu.org/module/claranet/linux-vm/azurerm/latest)

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
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
  resource_group_name = module.rg.name

  virtual_network_name = module.vnet.name

  # Bastion parameters
  bastion_vm_size         = "Standard_B1s"
  bastion_os_disk_size_gb = "32"

  admin_ssh_ips = var.admin_ssh_ips

  # Define your private ip bastion if you want to override it
  bastion_private_ip = "10.10.10.10"

  # Set to null to deactivate backup (not recommended)
  bastion_backup_policy_id = module.run.vm_backup_policy_id

  # Optional: Put your SSH key here
  ssh_public_key = tls_private_key.bastion.public_key_openssh

  # Define your subnets if you want to override it
  subnet = {
    cidrs = ["10.10.10.0/24"]
  }
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
| azurerm | ~> 4.26 |
| tls | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| azure\_region | claranet/regions/azurerm | ~> 8.0.2 |
| bastion\_vm | claranet/linux-vm/azurerm | ~> 8.5.0 |
| claranet\_gallery\_images | claranet/claranet-gallery-images/azapi | ~> 8.1.0 |
| support\_nsg | claranet/nsg/azurerm | ~> 8.1.0 |
| support\_subnet | claranet/subnet/azurerm | ~> 8.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet_network_security_group_association.subnet_bastion_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_password | Password for the administrator account of the virtual machine. | `string` | `null` | no |
| admin\_ssh\_ips | Claranet IPs allowed to use SSH on bastion. | `list(string)` | n/a | yes |
| admin\_username | Name of the administrator user. | `string` | `"claranet"` | no |
| azure\_monitor\_agent\_auto\_upgrade\_enabled | Automatically update agent when publisher releases a new version of the agent. | `bool` | `false` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version. | `string` | `"1.12"` | no |
| azure\_monitor\_data\_collection\_rule\_id | Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` if legacy agent is used. | `string` | n/a | yes |
| bastion\_backup\_policy\_id | Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup). | `string` | n/a | yes |
| bastion\_custom\_data | The Base64-Encoded Custom Data which should be used for the bastion. Changing this forces a new resource to be created. | `string` | `null` | no |
| bastion\_custom\_hostname | Custom Bastion hostname. | `string` | `""` | no |
| bastion\_custom\_name | VM Name as displayed on the console. | `string` | `""` | no |
| bastion\_dcr\_custom\_name | Custom name for Data Collection Rule. | `string` | `null` | no |
| bastion\_dns\_label\_custom\_name | Custom name for DNS label. | `string` | `null` | no |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | `map(string)` | `{}` | no |
| bastion\_identity | Map with identity block informations as described in [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity). | <pre>object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "identity_ids": [],<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| bastion\_ipconfig\_custom\_name | Custom name for IP Configuration. | `string` | `null` | no |
| bastion\_maintenance\_configurations\_ids | List of maintenance configurations to attach to this VM. | `list(string)` | `[]` | no |
| bastion\_nic\_accelerated\_networking\_enabled | Should Accelerated Networking be enabled? Defaults to false. | `bool` | `false` | no |
| bastion\_nic\_custom\_name | Custom name for NIC. | `string` | `null` | no |
| bastion\_os\_disk\_account\_type | The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. | `string` | `"Premium_ZRS"` | no |
| bastion\_os\_disk\_caching | Specifies the caching requirements for the OS Disk. | `string` | `"ReadWrite"` | no |
| bastion\_os\_disk\_custom\_name | Custom name for Bastion OS disk. | `string` | `""` | no |
| bastion\_os\_disk\_extra\_tags | Additional tags to set on the OS disk. | `map(string)` | `{}` | no |
| bastion\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes. | `string` | n/a | yes |
| bastion\_os\_disk\_tagging\_enabled | Should OS disk tagging be enabled? Defaults to `true`. | `bool` | `true` | no |
| bastion\_patch\_mode | Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`. | `string` | `"AutomaticByPlatform"` | no |
| bastion\_private\_ip | Allows to define the private IP to associate with the bastion. | `string` | `null` | no |
| bastion\_public\_ip\_custom\_name | Custom name for public IP. | `string` | `null` | no |
| bastion\_public\_ip\_enabled | Should a Public IP be attached to the Virtual Machine? | `bool` | `true` | no |
| bastion\_public\_ip\_zones | Zones for public IP attached to the Virtual Machine. Can be `null` if no zone distpatch. | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |
| bastion\_user\_data | The Base64-Encoded User Data which should be used for the bastion. | `string` | `null` | no |
| bastion\_vm\_image | Bastion Virtual Machine source image information. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference). This variable cannot be used if `vm_image_id` is already defined. Defaults to Claranet image. | <pre>object({<br/>    publisher = string<br/>    offer     = string<br/>    sku       = string<br/>    version   = string<br/>  })</pre> | `null` | no |
| bastion\_vm\_image\_id | The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null. Defaults to Claranet image. | `string` | `null` | no |
| bastion\_vm\_size | Bastion virtual machine size. | `string` | n/a | yes |
| bastion\_zone\_id | Index of the Availability Zone which the Bastion should be allocated in. | `number` | `null` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| default\_outbound\_access\_enabled | Enable or disable `default_outbound_access`. See [documentation](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access). | `bool` | `false` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store VM diagnostics. | `string` | n/a | yes |
| disable\_password\_authentication | Option to disable or enable password authentication if admin password is not set. | `bool` | `true` | no |
| disk\_controller\_type | Specifies the Disk Controller Type used for this Virtual Machine. Possible values are `SCSI` and `NVMe`. | `string` | `null` | no |
| disk\_encryption\_set\_id | ID of the disk encryption set to use to encrypt VM disks. | `string` | `null` | no |
| encryption\_at\_host\_enabled | Should all disks (including the temporary disk) attached to the Virtual Machine be encrypted by enabling Encryption at Host? [List of compatible Virtual Machine sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes). | `bool` | `true` | no |
| entra\_ssh\_login\_admin\_objects\_ids | Entra ID (aka AAD) objects IDs allowed to connect as administrator on the Virtual Machine. | `list(string)` | `[]` | no |
| entra\_ssh\_login\_enabled | Enable SSH logins with Entra ID (aka AAD). | `bool` | `false` | no |
| entra\_ssh\_login\_extension\_version | Virtual Machine extension version for Entra ID (aka AAD) SSH Login extension. | `string` | `"1.0"` | no |
| entra\_ssh\_login\_user\_objects\_ids | Entra ID (aka AAD) objects IDs allowed to connect as standard user on the Virtual Machine. | `list(string)` | `[]` | no |
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
| network\_security\_group\_custom\_name | Custom name for Network Security Group. | `string` | `null` | no |
| network\_watcher\_name | The name of the Network Watcher. Changing this forces a new resource to be created. | `string` | `null` | no |
| network\_watcher\_resource\_group\_name | The name of the resource group in which the Network Watcher was deployed. Changing this forces a new resource to be created. | `string` | `null` | no |
| nic\_extra\_tags | Additional tags to associate with your network interface. | `map(string)` | `{}` | no |
| nsg\_additional\_rules | Additional network security group rules to add. For arguments please refer to [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule#argument-reference). | <pre>list(object({<br/>    priority  = number<br/>    name      = string<br/>    direction = optional(string)<br/>    access    = optional(string)<br/>    protocol  = optional(string)<br/><br/>    source_port_range  = optional(string)<br/>    source_port_ranges = optional(list(string))<br/><br/>    destination_port_range  = optional(string)<br/>    destination_port_ranges = optional(list(string))<br/><br/>    source_address_prefix   = optional(string)<br/>    source_address_prefixes = optional(list(string))<br/><br/>    destination_address_prefix   = optional(string)<br/>    destination_address_prefixes = optional(list(string))<br/>  }))</pre> | `[]` | no |
| nsg\_extra\_tags | Additional tags to associate with your Network Security Group. | `map(string)` | `{}` | no |
| private\_link\_endpoint\_enabled | Enable or disable network policies for the Private Endpoint on the subnet. | `bool` | `true` | no |
| private\_link\_service\_enabled | Enable or disable network policies for the Private Link Service on the subnet. | `bool` | `true` | no |
| public\_ip\_extra\_tags | Additional tags to associate with your public IP. | `map(string)` | `{}` | no |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| route\_table\_name | The Route Table name to associate with the subnet. | `string` | `null` | no |
| route\_table\_rg | The Route Table RG to associate with the subnet. Default is the same RG than the subnet. | `string` | `null` | no |
| secure\_boot\_enabled | Specifies if Secure Boot is enabled for the Virtual Machine. Defaults to `true`. Changing this forces a new resource to be created. | `bool` | `true` | no |
| service\_endpoint\_policy\_ids | The list of IDs of Service Endpoint Policies to associate with the subnet. | `list(string)` | `null` | no |
| service\_endpoints | The list of Service endpoints to associate with the subnet. | `list(string)` | `[]` | no |
| ssh\_public\_key | SSH public key, generated if empty. | `string` | `null` | no |
| stack | Project stack name. | `string` | n/a | yes |
| subnet | The ID of the existing subnet or the address prefixes to use for the new subnet. | <pre>object({<br/>    id    = optional(string)<br/>    cidrs = optional(list(string), [])<br/>  })</pre> | n/a | yes |
| subnet\_custom\_name | Custom name for Subnet. | `string` | `null` | no |
| ultra\_ssd\_enabled | Specifies whether Ultra Disks is enabled (`UltraSSD_LRS` storage type for data disks). | `bool` | `null` | no |
| virtual\_network\_name | Bastion VM virtual network name. | `string` | n/a | yes |
| virtual\_network\_resource\_group\_name | Bastion VM virtual network resource group name, default to `resource_group_name` if empty. | `string` | `""` | no |
| vtpm\_enabled | Specifies if vTPM (virtual Trusted Platform Module) and Trusted Launch is enabled for the Virtual Machine. Defaults to `true`. Changing this forces a new resource to be created. | `bool` | `true` | no |

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
| bastion\_virtual\_machine\_name | Bastion virtual machine name. |
| bastion\_virtual\_machine\_os\_disk | Bastion virtual machine OS disk object. |
| module\_bastion\_vm | Module bastion Virtual Machine object. |
| module\_network\_security\_group | Module network security group object. |
| module\_subnet | Module subnet object. |
| network\_security\_group\_id | Network security group ID. |
| network\_security\_group\_name | Network security group name. |
| subnet\_cidrs | CIDR list of the created subnet. |
| subnet\_id | ID of the created subnet. |
| terraform\_module | Information about this Terraform module. |
<!-- END_TF_DOCS -->
