variable "app_name" {
  type        = string
  description = "Application name for tagging"
}

# --- RDS Configuration ---
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
    engine_version    = "15"
    instance_class    = "db.t3.micro"
    allocated_storage = 20
    db_name           = "rds_db"
  }
}

# --- Aurora Configuration ---
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
    engine_version = "15"
    instance_class = "db.t3.medium"
    db_name        = "aurora_db"
    instance_count = 1
  }
}

# --- Shared Credentials & Network ---
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

variable "db_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the DB subnet group"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security groups for the database"
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

