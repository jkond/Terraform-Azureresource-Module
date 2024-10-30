variable "location" {
  description = "Azure region to create resources in"
  type        = string
  default     = "East US"
}

variable "az_resourcegroup_name" {
  description = "Azure resource group details"
  type        = string
}

variable "storage_account_name" {
  description = "Azure storage account details"
  type        = string
}

variable "azurerm_service_plan" {
  description = "Azure service plan details"
  type        = string
}
variable "azurerm_virtualnetwork" {
  description = "Azure vnet details"
  type        = string
}
variable "azurerm_linux_webapp" {
  description = "Azure webapp details"
  type        = string
}
variable "private_endpoint" {
  description = "Azure webapp details"
  type        = string
}


variable "os_type" {
  description = "Azure service plan details"
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "Azure service plan sku details"
  type        = string
  default     = "B1"
}

variable "env_type" {
  description = "dev, test, prod, uat, or staging"
  type        = string
  default     = "dev"
}

variable "subscription_id" {
  description = "The Subscription ID to use"
  type        = string
}

variable "permissioned_object" {
  description = "The user or group being assigned permissions in this resource"
  type = string
}

variable "vnet_address_space" {
  description = "Address space for the subnet"
  type = string
}

variable "subnet_one" {
  description = "CIDR notation for subnet one"
  type = string 
}

variable "subnet_two" {
 description = "CIDR notation for subnet two"
 type = string
}

variable "private_service_connection_name" {
 description = "CIDR notation for subnet two"
 type = string
}

variable "azure_websites_privatelink"{
  description = "privatelinkname"
  type = string
}
variable "subnet_one_name" {
  description = "Azure subnet details"
  type        = string
}
variable "subnet_two_name" {
  description = "Azure subents details"
  type        = string
}
