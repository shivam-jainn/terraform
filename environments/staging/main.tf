module "networking" {
  source      = "../../modules/networking"
  vpc_name    = "staging-vpc"
  router_name = "staging-router"
  region      = "us-central1"
  subnets = {
    "staging-public" = "10.0.1.0/24"
    "staging-app"    = "10.0.10.0/22"
    "staging-db"     = "10.0.0.0/24"
  }
}