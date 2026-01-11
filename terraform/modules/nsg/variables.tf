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

variable "nsg_name" {
  type        = string
  description = "The name of the Azure Network Security Group. Used as a firewall on a subnet or a VM NIC" 
  default     = "nsg"
}

variable "nsg_type" {
  type        = string
  description = "Set to 'public' for internet-facing or 'private' for RFC 1918 internal rules."
  default     = "private"
}

variable "rfc_1918_prefixes" {
  type        = list(string)
  description = "Default private network ranges as per RFC 1918."
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "public_rules" {
  type = map(object({ priority = number, port = string }))
  default = {
    "AllowHTTP"  = { priority = 100, port = "80" }
    "AllowHTTPS" = { priority = 110, port = "443" }
  }
}

variable "private_rules" {
  type = map(object({ priority = number, port = string }))
  default = {
    "AllowAllInternal" = { priority = 100, port = "*" }
  }
}