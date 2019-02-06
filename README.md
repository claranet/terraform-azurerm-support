# Azure - Claranet Support stack

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin_ssh_ips | Claranet IPs allowed to use SSH on bastion | string | - | yes |
| client_name | Client name/account used in naming | string | - | yes |
| custom_disk_name | Bastion disk name as displayed in the console | string | `` | no |
| custom_username | Default username to create on the bastion | string | `` | no |
| custom_vm_hostname | Bastion hostname | string | `` | no |
| custom_vm_name | VM Name as displayed on the console | string | `` | no |
| environment | Project environment | string | - | yes |
| extra_tags | Additional tags to associate with your network security group. | map | `<map>` | no |
| extra_tags | Custom map of tags to apply on every resources | map | `<map>` | no |
| location | Azure region to use | string | - | yes |
| location_short | Short string for Azure location | string | - | yes |
| network_security_group_ids | The Network Security Group Ids list to associate with the subnet | list | `<list>` | no |
| nsg-name | Name used for nsg naming | string | `test` | no |
| private_ip_bastion | Allows to define the private ip to associate with the bastion | string | `` | no |
| resource_group_name | Name of the resource group | string | - | yes |
| route_table_ids | The Route Table Ids list to associate with the subnet | list | `<list>` | no |
| service_endpoints | The list of Service endpoints to associate with the subnet | list | `<list>` | no |
| stack | Project stack name | string | - | yes |
| subnet_cidr | The address prefix list to use for the subnet | list | - | yes |
| virtual_network_name | Virtual network name | string | - | yes |
| vm_size | Bastion virtual machine size | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion_network_interface_id | Bastion network interface id |
| bastion_network_interface_private_ip | Bastion private ip |
| bastion_network_public_ip | Bastion public ip |
| bastion_network_public_ip_id | Bastion public ip id |
| bastion_record_dns_id | Bastion record dns id |
| bastion_virtual_machine_id | Bastion virtual machine id |
| network_security_group_id | Network security group id |
| network_security_group_name | Network security group name |
| subnet_cidr | CIDR list of the created subnets |
| subnet_id | Ids of the created subnets |
| subnet_ip_configurations | The collection of IP Configurations with IPs within this subnet |
| subnet_name | Names list of the created subnet |