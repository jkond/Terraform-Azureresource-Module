output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resourcegroup.name
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storageaccount.name
}
output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.storageaccount.id
}