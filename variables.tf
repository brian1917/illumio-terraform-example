variable "illumio_pce_host" {
  type        = string
  description = "URL of the Illumio Policy Compute Engine to connect to"
}

variable "illumio_org_id" {
  type        = number
  description = "Illumio PCE Organization ID number"
}

variable "illumio_api_user" {
  type        = string
  description = "Illumio API User"
}

variable "illumio_api_secret" {
  type        = string
  description = "Illumio API Secret"
}