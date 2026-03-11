module "vpc" {
    source  = "terraform-google-modules/network/google//modules/vpc"
    version = "~> 16.1"

    project_id   = var.project_id
    network_name = var.vpc_name

    shared_vpc_host = false
}