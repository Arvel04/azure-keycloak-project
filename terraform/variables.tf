variable "resource_group_location" {
  default     = "West Europe"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type    = string
  default = "my-first-terraform-RG"   # Remplacez par le nom réel de votre groupe de ressources
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1ms"
}

variable "vm_username" {
  type    = string
  default = "secureadmin"   # Nom d'utilisateur pour la machine virtuelle
}

variable "vm_password" {
  type    = string
  default = "Password123!"  # Mot de passe pour la machine virtuelle
}

# Backend-specific variables (Backend Azure)
variable "storage_account_name" {
  type        = string
  description = "Storage account name for backend."
  default     = "arvel04"  # Remplacez par le nom réel de votre compte de stockage
}

variable "container_name" {
  type        = string
  description = "Container name for backend."
  default     = "tfstate"  # Remplacez par le nom du conteneur de stockage
}

variable "key" {
  type        = string
  description = "Key name for backend."
  default     = "terraform.tfstate"  # Nom du fichier d'état pour Terraform
}

# Optionnelles pour plus de flexibilité
variable "vnet_name" {
  type        = string
  default     = "my-first-terraform-network"
  description = "Name of the virtual network."
}

variable "subnet_name" {
  type        = string
  default     = "my-first-terraform-subnet"
  description = "Name of the subnet."
}

variable "nsg_name" {
  type        = string
  default     = "my-first-terraform-NSG"
  description = "Name of the Network Security Group."
}

variable "vm_name" {
  type        = string
  default     = "my-terraform-vm"
  description = "Name of the Virtual Machine."
}

variable "private_ip" {
  type        = string
  default     = "10.0.1.4"
  description = "Static private IP address for the network interface."
}

variable "os_disk_type" {
  type        = string
  default     = "Premium_LRS"
  description = "Type of storage account for OS disk."
}

variable "image_version" {
  type        = string
  default     = "latest"
  description = "Version of the Ubuntu Server image."
}