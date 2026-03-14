resource "aws_security_group" "frontend" {
  vpc_id = var.vpc_id
  name   = "${var.app_name}-frontend-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-frontend-sg"
  }
}

resource "aws_security_group" "backend" {
  vpc_id = var.vpc_id
  name   = "${var.app_name}-backend-sg"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-backend-sg"
  }
}

resource "aws_security_group" "db" {
  vpc_id = var.vpc_id
  name   = "${var.app_name}-db-sg"

  ingress {
    from_port       = 5432 # Default for Postgres
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  ingress {
    from_port       = 3306 # Default for MySQL/Aurora
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-db-sg"
  }
}

