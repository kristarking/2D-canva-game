variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "70faaaeb-e126-4ca7-95be-9e614709f37b"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "KingRG"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "KingVnet"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "KingSubnet"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "KingNSG"
}

variable "public_ip_name" {
  description = "Name of the Public IP address"
  type        = string
  default     = "King-ip"
}

variable "nic_name" {
  description = "Name of the Network Interface"
  type        = string
  default     = "KingNic"
}

variable "nic_private_ip" {
  description = "Private IP address for the NIC"
  type        = string
  default     = "10.0.1.4"
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
  default     = "Kingvm"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B2ms"
}

variable "vm_admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "king"
}

variable "vm_admin_password" {
  description = "Admin password for the Virtual Machine"
  type        = string
  default     = "Emmanuel2024!"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
