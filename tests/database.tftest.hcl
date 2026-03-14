provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock"
  secret_key                  = "mock"
}

variables {
  app_name               = "test"
  db_username            = "admin"
  db_password            = "pass-123"
  db_subnet_ids          = ["s1"]
  vpc_security_group_ids = ["sg1"]
  tags                   = {}
}

run "stg" {
  module {
    source = "./modules/database"
  }
  command = plan
  variables {
    enable_rds    = true
    enable_aurora = false
  }
  assert {
    condition     = length(aws_db_instance.rds) == 1
    error_message = "RDS failed"
  }
}

run "prd" {
  module {
    source = "./modules/database"
  }
  command = plan
  variables {
    enable_rds    = false
    enable_aurora = true
    aurora_config = {
      engine         = "aurora-postgresql"
      engine_version = "15.3"
      instance_class = "db.r5.large"
      db_name        = "prd"
      instance_count = 2
    }
  }
  assert {
    condition     = length(aws_rds_cluster.aurora) == 1
    error_message = "Aurora cluster failed"
  }
  assert {
    condition     = length(aws_rds_cluster_instance.aurora_instances) == 2
    error_message = "Aurora instance count failed"
  }
}
