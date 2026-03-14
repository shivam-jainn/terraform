variable "app_name" {
  type        = string
  description = "Simple App Name"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR range for VPC"
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

