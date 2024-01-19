locals {
  ssh_public_key  = coalesce(var.ssh_public_key, tls_private_key.ssh.public_key_openssh)
  ssh_private_key = var.ssh_public_key == null ? tls_private_key.ssh.private_key_pem : null

  vm_image_id = var.bastion_vm_image == null && var.bastion_vm_image_id == null ? module.claranet_gallery_images.claranet_ubuntu["22.04"].latest : var.bastion_vm_image_id
}
