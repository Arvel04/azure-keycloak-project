variable "resource_group_name" {
  type    = string
  default = "keycloak-terraform-rg"
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
  default = "azureuser"
}

variable "vm_password" {
  type    = string
  default = "Password123!"
}

variable "vm_name" {
  type    = string
  default = "keycloak-vm"
}
