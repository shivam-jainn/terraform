module "networking" {
  source      = "../../modules/networking"
  project_id  = var.project_id
  vpc_name    = var.vpc_name
  router_name = var.router_name
  region      = var.region
  subnets     = var.subnets
}
