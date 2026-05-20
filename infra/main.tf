terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
  }
  required_version = ">= 0.14.9"
}

variable "suscription_id" { type = string }
variable "sqladmin_username" { type = string }
variable "sqladmin_password" { type = string }

provider "azurerm" {
  features {}
  subscription_id = var.suscription_id
}

resource "random_integer" "ri" {
  min = 100
  max = 999
}

resource "azurerm_resource_group" "rg" {
  name     = "upt-arg-${random_integer.ri.result}"
  location = "eastus"
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "upt-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "upt-awa-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  depends_on          = [azurerm_service_plan.appserviceplan]
  site_config {
    minimum_tls_version = "1.2"
    always_on           = false
  }
}