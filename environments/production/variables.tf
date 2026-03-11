variable "project_id" {
  description = "GCP project ID for the production environment"
  type        = string
}

variable "region" {
  description = "The region where the resources will be created."
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "prod-vpc"
}

variable "router_name" {
  description = "Name of the Cloud Router"
  type        = string
  default     = "prod-router"
}

variable "subnets" {
  description = "List of subnet configurations for production"
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
  }))
}
