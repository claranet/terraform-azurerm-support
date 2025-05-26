module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "~> 8.0.2"

  azure_region = var.location
}
