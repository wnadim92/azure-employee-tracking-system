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

variable "subnet_type" {
  type        = string
  description = "Public facing or private facing subnet. (public or private). Based off selection, sets up NSG to block public IPs and allow ports internally. Otherwise only http ports allowed and external IPs are allowed for public"
  default     = "private"
}