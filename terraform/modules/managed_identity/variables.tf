variable "principal_name" {
  type        = string
  description = "The name of the user assigned managed identity's princpal name."
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