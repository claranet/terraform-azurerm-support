output "subnet_id" {
  description = "Ids of the created subnets"
  value       = "${module.support-subnet.subnet_id}"
}

output "subnet_cidr" {
  description = "CIDR list of the created subnets"
  value       = "${module.support-subnet.subnet_cidr}"
}

output "subnet_name" {
  description = "Names list of the created subnet"
  value       = "${module.support-subnet.subnet_name}"
}

output "subnet_ip_configurations" {
  description = "The collection of IP Configurations with IPs within this subnet"
  value       = "${module.support-subnet.subnet_ip_configurations}"
}

output "network_security_group_id" {
  description = "Network security group id"
  value       = "${module.support-network-security-group.network_security_group_id}"
}

output "network_security_group_name" {
  description = "Network security group name"
  value       = "${module.support-network-security-group.network_security_group_name}"
}

output "bastion_network_public_ip" {
  description = "Bastion public ip"
  value       = "${module.bastion.bastion_network_public_ip}"
}

output "bastion_network_public_ip_id" {
  description = "Bastion public ip id"
  value       = "${module.bastion.bastion_network_public_ip_id}"
}

output "bastion_network_interface_id" {
  description = "Bastion network interface id"
  value       = "${module.bastion.bastion_network_interface_id}"
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private ip"
  value       = "${module.bastion.bastion_network_interface_private_ip}"
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine id"
  value       = "${module.bastion.bastion_virtual_machine_id}"
}
