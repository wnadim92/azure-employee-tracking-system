
module "app_primary_region" {
    source                                               = "../modules/app"
    project_name                                         = var.project_name
    region                                               = var.primary_region
    environment                                          = var.environment
    vnet_address_spaces                                  = var.primary_region_vnet_address_spaces
    dns_servers                                          = var.primary_region_dns_servers
    emp_track_frontend_appgw_snet_cidr                   = var.primary_region_emp_track_frontend_appgw_snet_cidr
    emp_track_frontend_pe_snet_cidr                      = var.primary_region_emp_track_frontend_pe_snet_cidr
    emp_track_frontend_vnetintegration_snet_cidr         = var.primary_region_emp_track_frontend_vnetintegration_snet_cidr
    emp_track_middletier_pe_snet_cidr                    = var.primary_region_emp_track_middletier_pe_snet_cidr
    emp_track_middletier_vnetintegration_snet_cidr       = var.primary_region_emp_track_middletier_vnetintegration_snet_cidr
    emp_track_db_snet_cidr                               = var.primary_region_emp_track_db_snet_cidr
}

module "app_secondary_region" {
    count                                                = var.shouldBeMultiRegion == true ? 1 : 0
    source                                               = "../modules/app"
    project_name                                         = var.project_name
    region                                               = var.primary_region
    environment                                          = var.environment
    vnet_address_spaces                                  = var.secondary_region_vnet_address_spaces
    dns_servers                                          = var.secondary_region_dns_servers
    emp_track_frontend_appgw_snet_cidr                   = var.secondary_region_emp_track_frontend_appgw_snet_cidr
    emp_track_frontend_pe_snet_cidr                      = var.secondary_region_emp_track_frontend_pe_snet_cidr
    emp_track_frontend_vnetintegration_snet_cidr         = var.secondary_region_emp_track_frontend_vnetintegration_snet_cidr
    emp_track_middletier_pe_snet_cidr                    = var.secondary_region_emp_track_middletier_pe_snet_cidr
    emp_track_middletier_vnetintegration_snet_cidr       = var.secondary_region_emp_track_middletier_vnetintegration_snet_cidr
    emp_track_db_snet_cidr                               = var.secondary_region_emp_track_db_snet_cidr
}