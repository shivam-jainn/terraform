variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "App name"
  type        = string
  default     = "intui_app"
}

variable "subnets" {
  type = object({
    public_names   = list(string)
    private_names  = list(string)
    database_names = list(string)
  })
}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones to distribute subnets across"
}

variable "tags" {
  type        = map(string)
  description = "Base tags to apply to all resources"
  default     = {}
}

variable "route_tables" {
  type = map(object({
    routes = list(object({
      cidr_block = string
      gateway_id = string
    }))
  }))
  default     = {}
  description = "Custom route tables for specific network paths (Optional)"
}

variable "subnet_route_table_map" {
  type        = map(string)
  default     = {}
  description = "Map of subnet names to route table keys (Optional)"
}

variable "instance_type" {
  type        = string
  description = "AWS instance type"
}

variable "db_username" {
  type        = string
  description = "Master username"
  sensitive   = true

  validation {
    condition     = lower(var.db_username) != "admin"
    error_message = "db_username cannot be 'admin' for RDS/Aurora. Use a different master username."
  }
}

variable "db_password" {
  type        = string
  description = "Master password"
  sensitive   = true
}

variable "enable_rds" {
  type        = bool
  description = "Whether to enable standalone RDS instance"
  default     = false
}

variable "rds_config" {
  type = object({
    engine            = string
    engine_version    = string
    instance_class    = string
    allocated_storage = number
    db_name           = string
  })
  default = {
    engine            = "postgres"
    engine_version    = "15.3"
    instance_class    = "db.t3.micro"
    allocated_storage = 20
    db_name           = "rds_db"
  }
}

variable "enable_aurora" {
  type        = bool
  description = "Whether to enable Aurora Cluster"
  default     = false
}

variable "aurora_config" {
  type = object({
    engine         = string
    engine_version = string
    instance_class = string
    db_name        = string
    instance_count = number
  })
  default = {
    engine         = "aurora-postgresql"
    engine_version = "15.3"
    instance_class = "db.t3.medium"
    db_name        = "aurora_db"
    instance_count = 1
  }
}
