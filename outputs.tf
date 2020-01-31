output "subnet_ids" {
  description = "Ids of the created subnets"
  value       = module.support-subnet.subnet_ids
}

output "subnet_cidr_list" {
  description = "CIDR list of the created subnets"
  value       = module.support-subnet.subnet_cidr_list
}

output "subnet_names" {
  description = "Names list of the created subnet"
  value       = module.support-subnet.subnet_names
}

output "subnet_ip_configurations" {
  description = "The collection of IP Configurations with IPs within this subnet"
  value       = module.support-subnet.subnet_ip_configurations
}

output "network_security_group_id" {
  description = "Network security group id"
  value       = module.support-network-security-group.network_security_group_id
}

output "network_security_group_name" {
  description = "Network security group name"
  value       = module.support-network-security-group.network_security_group_name
}

output "bastion_network_public_ip" {
  description = "Bastion public ip"
  value       = module.bastion.bastion_network_public_ip
}

output "bastion_network_public_ip_id" {
  description = "Bastion public ip id"
  value       = module.bastion.bastion_network_public_ip_id
}

output "bastion_network_interface_id" {
  description = "Bastion network interface id"
  value       = module.bastion.bastion_network_interface_id
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private ip"
  value       = module.bastion.bastion_network_interface_private_ip
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine id"
  value       = module.bastion.bastion_virtual_machine_id
}

output "bastion_virtual_machine_name" {
  description = "Bastion virtual machine name"
  value       = module.bastion.bastion_virtual_machine_name
}

output "bastion_admin_username" {
  description = "Username of the admin user"
  value       = module.bastion.bastion_admin_username
}

output "bastion_virtual_machine_size" {
  description = "Bastion virtual machine size"
  value       = module.bastion.bastion_virtual_machine_size
}

output "bastion_hostname" {
  description = "Bastion hostname"
  value       = module.bastion.bastion_hostname
}

output "bastion_storage_image_reference" {
  description = "Bastion storage image reference object"
  value       = module.bastion.bastion_storage_image_reference
}

output "bastion_storage_os_disk" {
  description = "Bastion storage OS disk object"
  value       = module.bastion.bastion_storage_os_disk
}

output "bastion_public_domain_name_label" {
  description = "Bastion public DNS"
  value       = module.bastion.bastion_public_domain_name_label
}
