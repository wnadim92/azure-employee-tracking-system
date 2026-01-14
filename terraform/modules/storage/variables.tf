
variable "strg_name" {
  type        = string
  description = "The name of the storage account."
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

variable "blob_dns_zone_id" {
  type = string
}

variable "file_dns_zone_id" {
  type = string
}

variable "table_dns_zone_id" {
  type = string
}

variable "queue_dns_zone_id" {
  type = string
}

variable "principal_id" {
  type        = string
  description = "The id of the user assigned managed identity's princpal."
}

variable "public_network_access_enabled" {
  type    = bool
  default = false
}