variable "project_name" {}
variable "primary_region" {}
variable "environment" {}

variable "primary_region_vnet_address_spaces" {}
variable "primary_region_dns_servers" {}
variable "primary_region_emp_track_frontend_appgw_snet_cidr" {}
variable "primary_region_emp_track_frontend_pe_snet_cidr" {}
variable "primary_region_emp_track_frontend_vnetintegration_snet_cidr" {}
variable "primary_region_emp_track_middletier_pe_snet_cidr" {}
variable "primary_region_emp_track_middletier_vnetintegration_snet_cidr" {}
variable "primary_region_emp_track_db_snet_cidr" {}

variable "shouldBeMultiRegion" {}
variable "secondary_region" {}
variable "secondary_region_vnet_address_spaces" {}
variable "secondary_region_dns_servers" {}
variable "secondary_region_emp_track_frontend_appgw_snet_cidr" {}
variable "secondary_region_emp_track_frontend_pe_snet_cidr" {}
variable "secondary_region_emp_track_frontend_vnetintegration_snet_cidr" {}
variable "secondary_region_emp_track_middletier_pe_snet_cidr" {}
variable "secondary_region_emp_track_middletier_vnetintegration_snet_cidr" {}
variable "secondary_region_emp_track_db_snet_cidr" {}

variable "frontend_image_name" {}
variable "backend_image_name" {}
variable "docker_registry_url" {}
variable "image_tag" {}

variable "funcapp_name" {
  description = "The name of the Function App passed from GitHub Actions"
  type        = string
}

variable "webapp_name" {
  description = "The name of the Web App passed from GitHub Actions"
  type        = string
}

//ariable "zip_package_path" {}