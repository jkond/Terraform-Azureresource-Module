
####################################################################################
####### Resource Group
####################################################################################

resource "azurerm_resource_group" "resourcegroup" {
  name     = var.az_resourcegroup_name
  location = var.location
  
}

resource "azurerm_storage_account" "storageaccount" {
  name                          = var.storage_account_name
  resource_group_name           = azurerm_resource_group.resourcegroup.name
  location                      = azurerm_resource_group.resourcegroup.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true

}

resource "azurerm_service_plan" "service_plan" {
  name                = var.azurerm_service_plan
  resource_group_name = azurerm_storage_account.storageaccount.resource_group_name
  location            = azurerm_storage_account.storageaccount.location
  os_type             = var.os_type
  sku_name            = var.sku_name

  lifecycle { ignore_changes = [tags] }
}


resource "azurerm_virtual_network" "virtualnetwork" {
  name                = var.azurerm_virtualnetwork
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

tags = {
    "Cost Center" = "12531"
    Department  = "Platform Engineering"
    environment = var.env_type
  }

}
####################################################################################
####### Networking
####################################################################################



resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet_one_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = [var.subnet_one]

  private_endpoint_network_policies = "Enabled"

  private_link_service_network_policies_enabled = true

}

resource "azurerm_subnet" "subnet2" {
  name                 = var.subnet_two_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = [var.subnet_two]

   delegation {
    name = "Appservice"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }


  private_endpoint_network_policies = "Enabled"

  private_link_service_network_policies_enabled = true

}
#app service
resource "azurerm_linux_web_app" "webapp" {
  name                = var.azurerm_linux_webapp
  location            = azurerm_storage_account.storageaccount.location
  resource_group_name = azurerm_storage_account.storageaccount.resource_group_name
  service_plan_id     = azurerm_service_plan.service_plan.id

  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.UserAssignedIdentity.id]
  # }
  app_settings = {
  }
  site_config {

    application_stack {
        python_version        =        "3.11"
    }


    ip_restriction {
      name       = "chaska egress"
      ip_address = "206.15.205.10/32"
      priority   = 200
      action     = "Allow"
    }
    ip_restriction {
      name       = "ny5 egress"
      ip_address = "206.15.207.10/32"
      priority   = 300
      action     = "Allow"
    }

  }
  virtual_network_subnet_id = azurerm_subnet.subnet2.id
}

resource "azurerm_private_endpoint" "webapp_private_endpoint" {
  name                = var.private_endpoint
  location            = azurerm_storage_account.storageaccount.location
  resource_group_name = azurerm_storage_account.storageaccount.resource_group_name
  subnet_id           = azurerm_subnet.subnet1.id

  private_service_connection {
    name                           = var.private_service_connection_name
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_private_dns_zone" "azurewebsites_dnszone" {

  name                = var.azure_websites_privatelink
  resource_group_name = azurerm_storage_account.storageaccount.resource_group_name
  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_private_dns_a_record" "azurewebsites_dnszone_webapp" {
  name                = lower(azurerm_linux_web_app.webapp.name)
  zone_name           = azurerm_private_dns_zone.azurewebsites_dnszone.name
  resource_group_name = azurerm_storage_account.storageaccount.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.webapp_private_endpoint.private_service_connection.0.private_ip_address]
  lifecycle { ignore_changes = [tags] }
}

