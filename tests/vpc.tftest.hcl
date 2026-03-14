variables {
  vpc_cidr = "10.0.0.0/16"
  app_name = "test-vpc"
  azs      = ["us-east-1a"]
  subnets  = { public_names = ["p"], private_names = [], database_names = [] }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock"
  secret_key                  = "mock"
}

run "test_vpc" {
  module {
    source = "./modules/vpc"
  }
  command = plan
  assert {
    condition     = length(aws_subnet.subnets) == 1
    error_message = "VPC subnet count mismatch"
  }
}
