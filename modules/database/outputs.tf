output "db_subnet_group_id" {
  value = aws_db_subnet_group.db_subnet_group.id
}

output "rds_instance_id" {
  value = try(aws_db_instance.rds[0].id, "")
}

output "aurora_cluster_id" {
  value = try(aws_rds_cluster.aurora[0].id, "")
}
