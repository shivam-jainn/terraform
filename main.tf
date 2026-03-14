terraform {
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  app_name = var.app_name
  subnets  = var.subnets
  azs      = var.azs
  tags     = var.tags
}



module "security" {
  source   = "./modules/security"
  vpc_id   = module.vpc.vpc_id
  app_name = var.app_name
}

module "ec2" {
  source                     = "./modules/ec2"
  instance_type              = var.instance_type
  tier_subnet_ids            = module.vpc.tier_subnet_ids
  frontend_security_group_id = module.security.frontend_security_group_id
  backend_security_group_id  = module.security.backend_security_group_id
  app_name                   = var.app_name
}

module "database" {
  source        = "./modules/database"
  app_name      = var.app_name
  enable_rds    = var.enable_rds
  enable_aurora = var.enable_aurora
  rds_config    = var.rds_config
  aurora_config = var.aurora_config
  db_username   = var.db_username
  db_password   = var.db_password

  db_subnet_ids          = values(module.vpc.tier_subnet_ids["database"])
  vpc_security_group_ids = [module.security.db_security_group_id]
  tags                   = var.tags
}



