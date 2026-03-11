module "networking" {
  source      = "../../modules/networking"
  vpc_name    = "prod-vpc"
  router_name = "prod-router"
  region      = "us-central1"
  subnets     = var.subnets
}
