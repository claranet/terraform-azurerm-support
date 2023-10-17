output "subnet_id" {
  description = "ID of the created subnet."
  value       = module.support_subnet.subnet_id
}

output "subnet_cidr_list" {
  description = "CIDR list of the created subnet."
  value       = module.support_subnet.subnet_cidr_list
}

output "subnet_name" {
  description = "Name of the created subnet."
  value       = module.support_subnet.subnet_name
}

output "network_security_group_id" {
  description = "Network security group ID."
  value       = module.support_nsg.network_security_group_id
}

output "network_security_group_name" {
  description = "Network security group name."
  value       = module.support_nsg.network_security_group_name
}

output "bastion_network_public_ip" {
  description = "Bastion public IP."
  value       = module.bastion_vm.vm_public_ip_address
}

output "bastion_network_public_ip_id" {
  description = "Bastion public IP ID."
  value       = module.bastion_vm.vm_public_ip_id
}

output "bastion_network_interface_id" {
  description = "Bastion network interface ID."
  value       = module.bastion_vm.vm_nic_id
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private IP."
  value       = module.bastion_vm.vm_private_ip_address
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine ID."
  value       = module.bastion_vm.vm_id
}

output "bastion_virtual_machine_name" {
  description = "Bastion virtual machine name."
  value       = module.bastion_vm.vm_name
}

output "bastion_admin_username" {
  description = "Username of the admin user."
  value       = module.bastion_vm.vm_admin_username
  sensitive   = true
}

output "bastion_admin_password" {
  description = "Password of the admin user."
  value       = module.bastion_vm.vm_admin_password
  sensitive   = true
}

# FIXME not in linux-vm module
#output "bastion_virtual_machine_size" {
#  description = "Bastion virtual machine size."
#  value       = module.bastion_vm.vm_size
#}

output "bastion_hostname" {
  description = "Bastion hostname."
  value       = module.bastion_vm.vm_hostname
}

output "bastion_public_domain_name_label" {
  description = "Bastion public DNS."
  value       = module.bastion_vm.vm_public_domain_name_label
}

output "bastion_virtual_machine_identity" {
  description = "System Identity assigned to the bastion virtual machine."
  value       = module.bastion_vm.vm_identity
}

output "bastion_ssh_public_key" {
  description = "Bastion SSH public key."
  value       = module.bastion_vm.vm_admin_ssh_public_key
}

output "bastion_ssh_private_key" {
  description = "Bastion SSH private key."
  value       = local.ssh_private_key
  sensitive   = true
}

output "bastion_virtual_machine_os_disk" {
  description = "Bastion virtual machine OS disk object."
  value       = module.bastion_vm.vm_os_disk
}

output "bastion_maintenance_configurations_assignments" {
  description = "Maintenance configurations assignments configurations."
  value       = module.bastion_vm.maintenance_configurations_assignments
}
