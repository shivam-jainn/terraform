variable "project_id" {
  description = "GCP project ID for the staging environment"
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
  default     = "staging-vpc"
}

variable "router_name" {
  description = "Name of the router"
  type        = string
  default     = "staging-router"
}

variable "subnets" {
  description = "List of subnet configurations for staging"
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string
  }))
}