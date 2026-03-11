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
  description = "A map of subnets with their CIDR ranges"
  type        = map(string)
}
