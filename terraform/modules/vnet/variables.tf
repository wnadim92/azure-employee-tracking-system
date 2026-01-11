variable "rg_name" {
  type        = string
  description = "The name of the existing resource group."
}

variable "region" {
  type        = string
  description = "The Azure region for the VNet."  
  default     = "eastus"
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network."  
  default     = "vnet"
}

variable "address_spaces" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "The llist of address spaces used by the virtual network."
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "Optional list of DNS servers. If null, Azure-provided DNS is used."
}
