data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = values(var.tier_subnet_ids.public)[0]
  vpc_security_group_ids = [var.frontend_security_group_id]

  tags = {
    Name = "${var.app_name}-frontend-instance"
  }

  depends_on = [var.tier_subnet_ids, var.frontend_security_group_id]
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = values(var.tier_subnet_ids.private)[0]
  vpc_security_group_ids = [var.backend_security_group_id]

  tags = {
    Name = "${var.app_name}-backend-instance"
  }

  depends_on = [var.tier_subnet_ids, var.backend_security_group_id]
}

