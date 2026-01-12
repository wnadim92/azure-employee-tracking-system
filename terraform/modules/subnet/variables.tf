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

variable "delegation_service" {
  type        = string
  description = "The service name for subnet delegation (e.g., Microsoft.Web/serverFarms)"
  default     = null
}

variable "subnet_type" {
  type        = string
  description = "Public facing or private facing subnet. (public or private). Based off selection, sets up NSG to block public IPs and allow ports internally. Otherwise only http ports allowed and external IPs are allowed for public"
  default     = "private"
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet."
  default     = "internal-subnet"
}

variable "cidr" {
  type        = string
  description = "The cidr for the subnet."
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network this subnet belongs to."
}