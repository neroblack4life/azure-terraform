terraform {
    required_version = ">=1.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>3.0"
        }
        random = {
            source = "hashicorp/random"
            version = "~>3.0"
        }
        
    }
}
provider azurerm {
    features{}
}

variable "resouce_group_location" {
    default = "eastus"
    description = "location of the resource group."
}

variable "prefix" {
    type = string
    default = "windows-IIS-VM"
    decription = "Prefix of the resource name"
}

resource "random_pet" "prefix" {
    prefix = var.prefix
    lenght = 1 
}

resource "random_password" {
   lenght      = 20
   min_lower   = 1
   min_upper   = 1
   min_numeric = 1
   min_special = 1 
}

resource "random_id" {
    keepers = {
        resource_group = azurerm_resource_group.rg.name
    }
    byte_length = 8
}

resource "azurerm_resource_group" "rg" {
    name = "${random_pet.prefix.id}-rg"
    location = var.resource_group_location
}