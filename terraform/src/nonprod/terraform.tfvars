project_name        = "emptrack"
environment         = "nonprod"
docker_registry_url = "snadim92"
frontend_image_name = "emptrack-frontend"
backend_image_name  = "emptrack-backend"
shouldBeMultiRegion = false

#primary region
primary_region                                                = "eastus"
primary_region_vnet_address_spaces                            = ["10.2.0.0/16"]
primary_region_dns_servers                                    = ["8.8.8.8", "1.1.1.1"]
primary_region_emp_track_frontend_appgw_snet_cidr             = "10.2.0.0/24"
primary_region_emp_track_frontend_pe_snet_cidr                = "10.2.1.0/27"
primary_region_emp_track_frontend_vnetintegration_snet_cidr   = "10.2.1.32/27"
primary_region_emp_track_middletier_pe_snet_cidr              = "10.2.1.64/27"
primary_region_emp_track_middletier_vnetintegration_snet_cidr = "10.2.1.96/27"
primary_region_emp_track_db_snet_cidr                         = "10.2.1.128/27"

#secondary region
secondary_region                                                = "westus"
secondary_region_vnet_address_spaces                            = ["10.3.0.0/16"]
secondary_region_dns_servers                                    = ["8.8.8.8", "1.1.1.1"]
secondary_region_emp_track_frontend_appgw_snet_cidr             = "10.3.0.0/24"
secondary_region_emp_track_frontend_pe_snet_cidr                = "10.3.1.0/27"
secondary_region_emp_track_frontend_vnetintegration_snet_cidr   = "10.3.1.32/27"
secondary_region_emp_track_middletier_pe_snet_cidr              = "10.3.1.64/27"
secondary_region_emp_track_middletier_vnetintegration_snet_cidr = "10.3.1.96/27"
secondary_region_emp_track_db_snet_cidr                         = "10.3.1.128/27"
