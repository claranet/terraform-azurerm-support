module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "~> 7.3.1"

  azure_region = var.location
}
