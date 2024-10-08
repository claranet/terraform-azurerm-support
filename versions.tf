terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.108"
    }
    # tflint-ignore: terraform_unused_required_providers
    azurecaf = {
      source  = "claranet/azurecaf"
      version = "~> 1.2, >= 1.2.22"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
  }
}
