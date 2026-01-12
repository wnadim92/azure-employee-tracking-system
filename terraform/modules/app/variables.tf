variable "project_name" {
  type        = string
  description = "The name of the project."
  default     = "platform"
}

variable "region" {
  type        = string
  description = "The Azure region where the resource group will be provisioned."
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "The name of the environment (dev, uat, ... prod)"
}

variable "docker_registry_url" {
    type = string
}

variable "frontend_image_name" {}
variable "backend_image_name" {}

variable "vnet_address_spaces" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "The llist of address spaces used by the virtual network."
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "Optional list of DNS servers. If null, Azure-provided DNS is used."
}

variable "emp_track_frontend_appgw_snet_cidr" {
  type        = string
  description = "The cidr for the front end public appgw subnet"
}

variable "emp_track_frontend_pe_snet_cidr" {
  type        = string
  description = "The cidr for the front end private endpoint subnet"
}

variable "emp_track_frontend_vnetintegration_snet_cidr" {
  type        = string
  description = "The cidr for the front end vnet integration subnet"
}

variable "emp_track_middletier_pe_snet_cidr" {
  type        = string
  description = "The cidr for the middle tier pe subnet"
}

variable "emp_track_middletier_vnetintegration_snet_cidr" {
  type        = string
  description = "The cidr for the middle tier vnet integration subnet"
}

variable "emp_track_db_snet_cidr" {
  type        = string
  description = "The cidr for the db subnet"
}