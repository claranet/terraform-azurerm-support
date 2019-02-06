output "subnet_id" {
  description = "Ids of the created subnets"
  value       = "${module.support-subnet.*.id}"
}

output "subnet_cidr" {
  description = "CIDR list of the created subnets"
  value       = "${module.support-subnet.*.address_prefix}"
}

output "subnet_name" {
  description = "Names list of the created subnet"
  value       = "${module.support-subnet.*.name}"
}

output "subnet_ip_configurations" {
  description = "The collection of IP Configurations with IPs within this subnet"
  value       = "${module.support-subnet.*.ip_configurations}"
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
  value       = "${module.bastion.ip_address}"
}

output "bastion_network_public_ip_id" {
  description = "Bastion public ip id"
  value       = "${module.bastion.id}"
}

output "bastion_network_interface_id" {
  description = "Bastion network interface id"
  value       = "${module.bastion.id}"
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private ip"
  value       = "${module.bastion.private_ip_address}"
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine id"
  value       = "${module.bastion_instance.id}"
}

output "bastion_record_dns_id" {
  description = "Bastion record dns id"
  value       = "${module.record_bastion.id}"
}
