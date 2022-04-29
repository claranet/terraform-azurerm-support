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
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
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

module "az_monitor" {
  source  = "claranet/run-iaas/azurerm//modules/vm-monitoring"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  extra_tags = {
    foo = "bar"
  }
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

  # Diag/logs
  diagnostics_storage_account_name      = module.logs.logs_storage_account_name
  diagnostics_storage_account_sas_token = null # used by legacy agent only
  azure_monitor_data_collection_rule_id = module.az_monitor.data_collection_rule_id
  log_analytics_workspace_guid          = module.logs.log_analytics_workspace_guid
  log_analytics_workspace_key           = module.logs.log_analytics_workspace_primary_key
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.83 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| bastion | github.com/claranet/terraform-azurerm-bastion-vm.git | v5.2.0 |
| support\_nsg | claranet/nsg/azurerm | 5.1.0 |
| support\_subnet | claranet/subnet/azurerm | 5.0.0 |

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
| ani\_extra\_tags | Additional tags to associate with your network interface | `map(string)` | `{}` | no |
| azure\_monitor\_agent\_auto\_upgrade\_enabled | Automatically update agent when publisher releases a new version of the agent | `bool` | `false` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version | `string` | `"1.12"` | no |
| azure\_monitor\_data\_collection\_rule\_id | Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` if legacy agent is used. | `string` | n/a | yes |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance | `map(string)` | `{}` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_bastion\_subnet\_name | Custom name for bastion subnet | `string` | `null` | no |
| custom\_ipconfig\_name | Custom name for IP Configuration | `string` | `null` | no |
| custom\_nic\_name | Custom name for NIC | `string` | `null` | no |
| custom\_public\_ip\_name | Custom name for public IP | `string` | `null` | no |
| custom\_security\_group\_name | Custom name for network security group | `string` | `null` | no |
| custom\_vm\_hostname | Bastion hostname | `string` | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store VM diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | SAS token of the Storage Account in which store VM diagnostics. Used only with legacy monitoring agent, set to `null` if not needed. | `string` | `null` | no |
| environment | Project environment | `string` | n/a | yes |
| location | Azure location | `string` | n/a | yes |
| location\_short | Short string for Azure location | `string` | n/a | yes |
| log\_analytics\_agent\_enabled | Deploy Log Analytics VM extension - depending of OS (cf. https://docs.microsoft.com/fr-fr/azure/azure-monitor/agents/agents-overview#linux) | `bool` | `true` | no |
| log\_analytics\_agent\_version | Azure Log Analytics extension version | `string` | `"1.13"` | no |
| log\_analytics\_workspace\_guid | GUID of the Log Analytics Workspace to link with | `string` | `null` | no |
| log\_analytics\_workspace\_key | Access key of the Log Analytics Workspace to link with | `string` | `null` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `"bastion"` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| nsg\_extra\_tags | Additional tags to associate with your Network Security Group | `map(string)` | `{}` | no |
| private\_ip\_bastion | Allows to define the private IP to associate with the bastion | `string` | `"10.10.1.10"` | no |
| pubip\_extra\_tags | Additional tags to associate with your public IP | `map(string)` | `{}` | no |
| public\_ip\_sku | Public IP SKU attached to the bastion VM. Can be `null` if no public IP is needed.<br>If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private IP. <br>Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory. | `string` | `"Standard"` | no |
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
| storage\_os\_disk\_extra\_tags | Additional tags to set on the OS disk | `map(string)` | `{}` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes | `string` | n/a | yes |
| storage\_os\_disk\_tagging\_enabled | Should OS disk tagging be enabled? Defaults to `true` | `bool` | `true` | no |
| subnet\_cidr\_list | The address prefixes to use for the subnet | `list(string)` | <pre>[<br>  "10.10.1.0/24"<br>]</pre> | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_*_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_legacy\_monitoring\_agent | True to use the legacy monitoring agent instead of Azure Monitor Agent | `bool` | `false` | no |
| virtual\_network\_name | Virtual network name | `string` | n/a | yes |
| virtual\_network\_resource\_group\_name | Virtual network resource group name, default to `resource_group_name` if empty | `string` | `""` | no |
| vm\_size | Bastion virtual machine size | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_admin\_username | Username of the admin user |
| bastion\_hostname | Bastion hostname |
| bastion\_network\_interface\_id | Bastion network interface ID |
| bastion\_network\_interface\_private\_ip | Bastion private IP |
| bastion\_network\_public\_ip | Bastion public IP |
| bastion\_network\_public\_ip\_id | Bastion public IP ID |
| bastion\_public\_domain\_name\_label | Bastion public DNS |
| bastion\_ssh\_private\_key | Bastion SSH private key |
| bastion\_ssh\_public\_key | Bastion SSH public key |
| bastion\_virtual\_machine\_id | Bastion virtual machine ID |
| bastion\_virtual\_machine\_identity | System Identity assigned to the bastion virtual machine |
| bastion\_virtual\_machine\_name | Bastion virtual machine name |
| bastion\_virtual\_machine\_size | Bastion virtual machine size |
| network\_security\_group\_id | Network security group ID |
| network\_security\_group\_name | Network security group name |
| subnet\_cidr\_list | CIDR list of the created subnet |
| subnet\_id | ID of the created subnet |
| subnet\_name | Name of the created subnet |
<!-- END_TF_DOCS -->
