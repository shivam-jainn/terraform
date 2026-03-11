module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  router     = var.router_name
  project_id = var.project_id
  region     = var.region
  create_router = true
}