# Nom du groupe de ressources
output "resource_group_name" {
  value       = var.resource_group_name
  description = "Le nom du groupe de ressources"
}

# IP publique de la VM
output "VM_IP" {
  value       = azurerm_public_ip.my_terraform_public_ip.ip_address
  description = "L'adresse IP publique de la VM"
}

Clé privée TLS pour SSH (sensible)
output "private_key" {
  value       = tls_private_key.secureadmin_ssh.private_key_pem
  description = "La clé privée pour l'accès SSH"
  sensitive   = true
}

output "ssh_public_key" {
  value = tls_private_key.secureadmin_ssh.public_key_openssh
}

# Nom de la VM
output "vm_name" {
  value       = azurerm_linux_virtual_machine.my_terraform_vm.name
  description = "Le nom de la machine virtuelle"
}

# IP privée de la VM
output "vm_private_ip" {
  value       = azurerm_network_interface.my_terraform_nic.ip_configuration[0].private_ip_address
  description = "L'adresse IP privée de la VM"
}

# Nom d'utilisateur pour la VM
output "vm_username" {
  value       = var.vm_username
  description = "Le nom d'utilisateur pour la VM"
}

# Mot de passe pour la VM
output "vm_password" {
  value       = var.vm_password
  description = "Le mot de passe pour la VM"
}
