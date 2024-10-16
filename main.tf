terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Create a Resource Group
resource "azurerm_resource_group" "KingRG" {
  name     = var.resource_group_name
  location = var.location
}


# Create a Virtual Network
resource "azurerm_virtual_network" "KingVnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create a Public Subnet
resource "azurerm_subnet" "KingSubnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.KingRG.name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_address_prefix]
}

# Create a Network Security Group (NSG)
resource "azurerm_network_security_group" "KingNSG" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create NSG Rule for Port 22 (SSH)
resource "azurerm_network_security_rule" "SSH" {
  name                        = "Allow-SSH"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.KingNSG.name
  resource_group_name         = azurerm_resource_group.KingRG.name
}

# Create NSG Rule for Port 80 (HTTP)
resource "azurerm_network_security_rule" "HTTP" {
  name                        = "Allow-HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.KingNSG.name
  resource_group_name         = var.resource_group_name
}

# Create a Public IP Address
resource "azurerm_public_ip" "King-ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# Create a Network Interface (NIC)
resource "azurerm_network_interface" "KingNic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.KingSubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.nic_private_ip
    public_ip_address_id          = azurerm_public_ip.King-ip.id
  }
}
# Connect NiC And NSG
resource "azurerm_network_interface_security_group_association" "KingCo" {
  network_interface_id      = azurerm_network_interface.KingNic.id
  network_security_group_id = azurerm_network_security_group.KingNSG.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "Kingvm" {
  name                            = var.vm_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  network_interface_ids           = [azurerm_network_interface.KingNic.id]
  disable_password_authentication = true

  #SSH Public Key 
  admin_ssh_key {
    username   = "king"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  # OS Disk Configuration
  os_disk {
    name                 = "KingOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Source Image Reference (Ubuntu 22.04 LTS)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

