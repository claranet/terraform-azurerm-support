output "subnet_id" {
  description = "ID of the created subnet"
  value       = module.support_subnet.subnet_id
}

output "subnet_cidr_list" {
  description = "CIDR list of the created subnet"
  value       = module.support_subnet.subnet_cidr_list
}

output "subnet_name" {
  description = "Name of the created subnet"
  value       = module.support_subnet.subnet_names
}

output "network_security_group_id" {
  description = "Network security group id"
  value       = module.support_nsg.network_security_group_id
}

output "network_security_group_name" {
  description = "Network security group name"
  value       = module.support_nsg.network_security_group_name
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

output "bastion_public_domain_name_label" {
  description = "Bastion public DNS"
  value       = module.bastion.bastion_public_domain_name_label
}

output "bastion_virtual_machine_identity" {
  description = "System Identity assigned to Bastion virtual machine"
  value       = module.bastion.bastion_virtual_machine_identity
}
