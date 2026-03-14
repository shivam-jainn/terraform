output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the created VPC"
}

output "subnet_ids" {
  value       = { for k, v in aws_subnet.subnets : k => v.id }
  description = "Map of subnet keys to IDs"
}

output "tier_subnet_ids" {
  value = {
    public   = { for k, v in aws_subnet.subnets : k => v.id if v.tags["Tier"] == "public" }
    private  = { for k, v in aws_subnet.subnets : k => v.id if v.tags["Tier"] == "private" }
    database = { for k, v in aws_subnet.subnets : k => v.id if v.tags["Tier"] == "database" }
  }
}

