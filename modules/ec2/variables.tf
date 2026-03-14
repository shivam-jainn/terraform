variable "instance_type" {
  type        = string
  description = "EC2 instance type (e.g., t2.micro)"
}

variable "tier_subnet_ids" {
  type = object({
    public   = map(string)
    private  = map(string)
    database = map(string)
  })
}

variable "frontend_security_group_id" {
  type        = string
  description = "ID of the security group to attach to the frontend instance"
}

variable "backend_security_group_id" {
  type        = string
  description = "ID of the security group to attach to the backend instance"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
}
