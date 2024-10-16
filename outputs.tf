# Output the Public IP Address
output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.King-ip.ip_address
}
output "resource_group_name" {
  description = "The name of the resource group"
  value       = var.resource_group_name
}

output "location" {
  description = "The location where resources are deployed"
  value       = var.location
}
