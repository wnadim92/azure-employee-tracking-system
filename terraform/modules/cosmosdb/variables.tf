variable "db_name" {
  type        = string
  description = "The name of the db."
  default     = "platform"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group."
  default     = "rg"
}

variable "region" {
  type        = string
  description = "The Azure region where the resource group will be provisioned."
  default     = "eastus"
}

variable "subnet_id" {
  type        = string
  description = "The subnet id to attach the pe to."
}

variable "private_dns_zone_id" {
  type        = string
  description = "The dns zone id to attach the pe to."
}

variable "principal_id" {
  type        = string
  description = "The id of the user assigned managed identity's princpal."
}