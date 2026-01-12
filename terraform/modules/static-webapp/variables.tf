variable "rg_name" {
  type        = string
  description = "The name of the resource group."
  default     = "rg"
}


variable "app_svc_name" {
  type        = string
}

variable "docker_registry_url" {
    type = string
}

variable "image_name" {
    type = string
}

variable "region" {
  type        = string
  description = "The Azure region where the resource group will be provisioned."
  default     = "centralindia"
}

variable "uami_resource_id" {
  type        = string
}