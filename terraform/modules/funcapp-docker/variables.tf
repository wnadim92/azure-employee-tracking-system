
variable "funcapp_name" {
  type = string
}

variable "docker_registry_url" {
  type = string
}

variable "image_name" {
  type = string
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

variable "vnet_integration_subnet_id" {
  type        = string
  description = "The subnet id to attach the pe to."
}

variable "pe_subnet_id" {
  type        = string
  description = "The subnet id to attach the pe to."
}

variable "sites_dns_zone_id" {
  type        = string
  description = "The dns zone id to attach the pe to."
}

variable "cosmosdb_endpoint" {
  type = string
}

variable "uami_resource_id" {
  type = string
}

variable "uami_client_id" {
  type = string
}

variable "uami_principal_id" {
  type = string
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
