output "module_subnet" {
  description = "Module subnet object."
  value       = one(module.support_subnet[*])
}

output "subnet_id" {
  description = "ID of the created subnet."
  value       = try(module.support_subnet[0].id, var.subnet.id)
}

output "subnet_cidrs" {
  description = "CIDR list of the created subnet."
  value       = try(module.support_subnet[0].cidrs, var.subnet.cidrs)
}

output "module_network_security_group" {
  description = "Module network security group object."
  value       = module.support_nsg
}

output "network_security_group_id" {
  description = "Network security group ID."
  value       = module.support_nsg.id
}

output "network_security_group_name" {
  description = "Network security group name."
  value       = module.support_nsg.name
}

output "module_bastion_vm" {
  description = "Module bastion Virtual Machine object."
  value       = module.bastion_vm
}

output "bastion_network_public_ip" {
  description = "Bastion public IP."
  value       = module.bastion_vm.public_ip_address
}

output "bastion_network_public_ip_id" {
  description = "Bastion public IP ID."
  value       = module.bastion_vm.public_ip_id
}

output "bastion_network_interface_id" {
  description = "Bastion network interface ID."
  value       = module.bastion_vm.nic_id
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private IP."
  value       = module.bastion_vm.private_ip_address
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine ID."
  value       = module.bastion_vm.id
}

output "bastion_virtual_machine_name" {
  description = "Bastion virtual machine name."
  value       = module.bastion_vm.name
}

output "bastion_admin_username" {
  description = "Username of the admin user."
  value       = module.bastion_vm.admin_username
  sensitive   = true
}

output "bastion_admin_password" {
  description = "Password of the admin user."
  value       = module.bastion_vm.admin_password
  sensitive   = true
}

output "bastion_hostname" {
  description = "Bastion hostname."
  value       = module.bastion_vm.hostname
}

output "bastion_public_domain_name_label" {
  description = "Bastion public DNS."
  value       = module.bastion_vm.public_domain_name_label
}

output "bastion_ssh_public_key" {
  description = "Bastion SSH public key."
  value       = module.bastion_vm.admin_ssh_public_key
}

output "bastion_ssh_private_key" {
  description = "Bastion SSH private key."
  value       = local.ssh_private_key
  sensitive   = true
}

output "bastion_virtual_machine_os_disk" {
  description = "Bastion virtual machine OS disk object."
  value       = module.bastion_vm.resource_os_disk
}

output "bastion_maintenance_configurations_assignments" {
  description = "Maintenance configurations assignments configurations."
  value       = module.bastion_vm.resource_maintenance_configuration_assignment
}
