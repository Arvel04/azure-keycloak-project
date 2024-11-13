output "resource_group_name" {
  value = "my-first-terraform-RG" 
}

output "VM_IP" {
  value = azurerm_public_ip.my_terraform_public_ip.ip_address
  description = "The public IP address of the VM"
}

output "tls_private_key" {
  value     = tls_private_key.secureadmin_ssh.private_key_pem
  sensitive = true
}

output "private_key" {
  value       = tls_private_key.secureadmin_ssh.private_key_pem
  description = "La clé privée pour l'accès SSH"
  sensitive   = true
}
