variable "GCP_Region" {
    description = "The region where the resources will be created."
    type        = string
    default     = "us-central1"
}

variable "app_subnet_cidr" {
    description = "The CIDR block for the app subnet."
    type        = string
    default     = "10.0.10.0/22"
}

variable "db_subnet_cidr" {
    description = "The CIDR block for the database subnet."
    type        = string
    default     = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for public subnet"
  type = string
  default = "10.0.0.0/24"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type = string
  default = "custom-vpc"
}

variable "router_name" {
  description = "Name of the router"
  type = string
  default = "my-router"
}

variable "subnets" {
  type = map(string)
}