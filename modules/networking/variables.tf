variable "project_id" {
  description = "GCP project ID for networking resources"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "region" {
  description = "GCP Region for the networking resources"
  type        = string
}

variable "router_name" {
  description = "Name of the Cloud Router"
  type        = string
}

variable "subnets" {
  description = "List of subnet configurations"
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
  }))
}
