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
    description = "Prefix of the resource name"
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
   special = true 
}

resource "random_id" {
    keepers = {
        resource_group = azurerm_resource_group.rg.name
    }
    byte_length = 8
}

resource "azurerm_resource_group" "rg" {
    name                  = "${random_pet.prefix.id}-rg"
    location              = var.resource_group_location
}

# Create Virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
    name                  = "${random_pet.prefix.id}-vnet"
    resource_group_name   = azurerm_resource_group.rg.name
    address_space         = "[10.0.0.0/16]"
    location              = azurerm_resource_group.rg.location
}

# Create a Subnet
resource "azurerm_subnet" "my_terraform_subnet" {
    name                  = "${random_pet.prefix.id}-subnet"
    resource_group_name   = azurerm_resource_group.rg.name
    virtual_network_name  = azurerm_virtual_network.my_terraform_network.name
    address_prefixes      = "[10.0.1.0/24]"
}

# Create Public IP
resource "azurerm_public_ip" "my_terraform_public_ip" {
    name                  = "${random_pet.prefix.id}-public-ip"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    allocation_method     = "Dynamic"
}

# Create NSG & Rules
resource "" "" {
    
}