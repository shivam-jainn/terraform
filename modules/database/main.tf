resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.app_name}-db-subnet-group"
  })
}

# --- RDS Section ---
resource "aws_db_instance" "rds" {
  count = var.enable_rds ? 1 : 0

  identifier             = "${var.app_name}-rds"
  engine                 = var.rds_config.engine
  engine_version         = var.rds_config.engine_version
  instance_class         = var.rds_config.instance_class
  allocated_storage      = var.rds_config.allocated_storage
  db_name                = var.rds_config.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = var.skip_final_snapshot

  tags = merge(var.tags, {
    Name = "${var.app_name}-rds"
  })
}

# --- Aurora Section ---
resource "aws_rds_cluster" "aurora" {
  count = var.enable_aurora ? 1 : 0

  cluster_identifier     = "${var.app_name}-aurora-cluster"
  engine                 = var.aurora_config.engine
  engine_version         = var.aurora_config.engine_version
  database_name          = var.aurora_config.db_name
  master_username        = var.db_username
  master_password        = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = var.skip_final_snapshot

  tags = merge(var.tags, {
    Name = "${var.app_name}-aurora-cluster"
  })
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count = var.enable_aurora ? var.aurora_config.instance_count : 0

  identifier         = "${var.app_name}-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora[0].id
  instance_class     = var.aurora_config.instance_class
  engine             = aws_rds_cluster.aurora[0].engine
  engine_version     = aws_rds_cluster.aurora[0].engine_version

  tags = merge(var.tags, {
    Name = "${var.app_name}-aurora-instance-${count.index}"
  })
}

