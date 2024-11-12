# Utilisation du groupe de ressources existant
#resource "azurerm_resource_group" "rg" {
  # Cette ressource est désormais inutile, mais vous pouvez la garder en tant que référence si nécessaire
  # location = var.resource_group_location
  #name     = "my-first-terraform-RG"  # Nom du groupe de ressources existant
#}

# Utilisation du compte de stockage existant
#resource "azurerm_storage_account" "tf_state_storage" {
  # Cette ressource est désormais inutile, mais vous pouvez la garder si vous avez besoin d'une référence
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

# Autres ressources Terraform (réseau, machine virtuelle, etc.)
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "my-first-terraform-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "my-first-terraform-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "my-first-terraform-PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "my-first-terraform-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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

resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "my-first-terraform-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my-nic-configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "my_nic_nsg" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

resource "tls_private_key" "secureadmin_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "my-terraform-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "my-terraform-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "terraform-vm"
  admin_username                  = "secureadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "secureadmin"
    public_key = tls_private_key.secureadmin_ssh.public_key_openssh
  }
}
