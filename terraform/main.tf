# wurde Manuel erstellt
#resource "azurerm_resource_group" "rg" {
  # Cette ressource est désormais inutile, mais vous pouvez la garder en tant que référence si nécessaire
  # location = var.resource_group_location
  #name     = "my-first-terraform-RG"  # Nom du groupe de ressources existant
#}

# Utilisation du compte de stockage existant
#resource "azurerm_storage_account" "tf_state_storage" {
  #Cette ressource est désormais inutile, mais vous pouvez la garder si vous avez besoin d'une référence
  #name                     = "arvel04"
 # resource_group_name      = "my-first-terraform-RG"  # Nom du groupe de ressources existant
  #location                 = "East US"  # Spécifiez la même localisation que votre groupe de ressources
  #account_tier             = "Standard"
  #account_replication_type = "LRS"
  #allow_blob_public_access = false
#}

# Conteneur de stockage pour l'état Terraform
#resource "azurerm_storage_container" "tf_state_container" {
#  name                  = "tfstate"
#  storage_account_name  = "arvel04"
#  container_access_type = "private"
#}
# Configuration du backend distant pour Terraform
terraform {
  backend "azurerm" {
    resource_group_name   = var.resource_group_name
    storage_account_name  = var.storage_account_name
    container_name        = var.container_name
    key                   = var.key
  }
}

# Réseau virtuel
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Sous-réseau
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# IP public
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "my-first-terraform-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

# Sécurité réseau (NSG)
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Interface réseau (NIC)
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "my-first-terraform-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "my-nic-configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address            = var.private_ip
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Association du NSG à la NIC
resource "azurerm_network_interface_security_group_association" "my_nic_nsg" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Clé privée TLS pour SSH
resource "tls_private_key" "secureadmin_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Machine virtuelle Linux
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "my-terraform-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = var.image_version
  }

  computer_name                   = "terraform-vm"
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password 
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.vm_username
    public_key = tls_private_key.secureadmin_ssh.public_key_openssh
  }
}
