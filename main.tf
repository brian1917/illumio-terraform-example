terraform {
  required_providers {
    illumio-core = {
      source  = "illumio/illumio-core"
    }
  }
}

provider "illumio-core" {
  pce_host     = var.illumio_pce_host
  org_id       = var.illumio_org_id
  api_username = var.illumio_api_user
  api_secret   = var.illumio_api_secret
}
