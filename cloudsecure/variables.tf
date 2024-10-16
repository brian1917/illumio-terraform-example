variable "iam_name_prefix" {
  description = "The prefix given to all AWS IAM resource names."
  type        = string
  default     = "IllumioCloudIntegrationTF"
  validation {
    condition     = length(var.iam_name_prefix) > 0
    error_message = "The iam_name_prefix value must not be empty."
  }
}

variable "illumio_cloudsecure_account_id" {
  description = "The CloudSecure AWS account ID that is given the IAM role."
  type        = string
 default     = "712001342241"
  validation {
    condition     = length(var.illumio_cloudsecure_account_id) == 12
    error_message = "The illumio_cloudsecure_account_id value must be a 12-digit number."
  }
}

variable "mode" {
  description = "The account's access mode, must be \"ReadWrite\" (default) or \"Read\"."
  type        = string
  default     = "ReadWrite"
  validation {
    condition     = contains(["Read", "ReadWrite"], var.mode)
    error_message = "The mode value must be \"ReadWrite\" or \"Read\"."
  }
}

variable "name" {
  description = "The name of this account in CloudSecure."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "The name value must not be empty."
  }
}

variable "tags" {
  description = "The optional tags added to every configured AWS resource."
  type        = map(string)
  default     = {}
}

variable "cloudsecure_client_id" {
  description = "The client id of the CloudSecure API credentials"
  type        = string
  validation {
    condition     = length(var.cloudsecure_client_id) > 0
    error_message = "The CloudSecure client ID must not be empty."
  }
}

variable "cloudsecure_client_secret" {
  description = "The client secret of the CloudSecure API credentials"
  type        = string
  validation {
    condition     = length(var.cloudsecure_client_secret) > 0
    error_message = "The CloudSecure client secret must not be empty."
  }
}