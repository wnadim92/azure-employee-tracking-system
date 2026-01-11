variable "project_name" {
  type        = string
  description = "The name of the resource group."  
  default     = "platform"
}

variable "region" {
  type        = string
  description = "The Azure region where the resource group will be provisioned." 
  default     = "eastus"
}

variable "environment" {
    type = string
    description = "The name of the environment (dev, uat, ... prod)"
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
