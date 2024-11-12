output "resource_group_name" {
  value = "my-first-terraform-RG" 
}

output "public_ip_address" {
  value = azurerm_public_ip.my_terraform_public_ip.ip_address
  description = "Adresse IP publique de la VM"
}

output "tls_private_key" {
  value     = tls_private_key.secureadmin_ssh.private_key_pem
  sensitive = true
}

