module "vpc" {
    source  = "terraform-google-modules/network/google//modules/subnets"
    version = "~> 16.1"

    project_id   = var.project_id
    network_name = var.vpc_name

    subnets = var.subnets 

    #remove this if you need multiregion subnets
    subnets_region=var.region 
}