locals {
  # Common tags for standardization
  common_tags = merge(var.tags, {
    Project     = var.app_name
    ManagedBy   = "Terraform"
    Environment = terraform.workspace
  })

  # Multi-AZ Distribution using modulo to wrap names around available AZs
  public_subnets = { for i, name in var.subnets.public_names : name => {
    netnum = i,
    tier   = "public",
    public = true,
    az     = var.azs[i % length(var.azs)]
  } }
  private_subnets = { for i, name in var.subnets.private_names : name => {
    netnum = i + 10,
    tier   = "private",
    public = false,
    az     = var.azs[i % length(var.azs)]
  } }
  database_subnets = { for i, name in var.subnets.database_names : name => {
    netnum = i + 20,
    tier   = "database",
    public = false,
    az     = var.azs[i % length(var.azs)]
  } }

  all_subnets = merge(local.public_subnets, local.private_subnets, local.database_subnets)
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-vpc"
  })
}

resource "aws_subnet" "subnets" {
  for_each = local.all_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value.netnum)
  map_public_ip_on_launch = each.value.public
  availability_zone       = each.value.az

  tags = merge(local.common_tags, {
    Name = each.key
    Tier = each.value.tier
  })
}

# 1️⃣ NAT Gateway Setup
resource "aws_eip" "nat" {
  for_each = length(var.subnets.public_names) > 0 ? toset([var.subnets.public_names[0]]) : toset([])
  domain   = "vpc"
  tags     = merge(local.common_tags, { Name = "${var.app_name}-nat-eip" })
}

resource "aws_nat_gateway" "main" {
  for_each      = aws_eip.nat
  allocation_id = each.value.id
  subnet_id     = aws_subnet.subnets[each.key].id
  tags          = merge(local.common_tags, { Name = "${var.app_name}-nat-gw" })

  depends_on = [aws_internet_gateway.gw]
}

# 2️⃣ Routing Infrastructure
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "${var.app_name}-igw" })
}

# Separated route tables for Public vs Private/Database
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(local.common_tags, { Name = "${var.app_name}-public-rt" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = length(aws_nat_gateway.main) > 0 ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = values(aws_nat_gateway.main)[0].id
    }
  }

  tags = merge(local.common_tags, { Name = "${var.app_name}-private-rt" })
}

# 3️⃣ Structured Associations
resource "aws_route_table_association" "public" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = merge(local.private_subnets, local.database_subnets)
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.private.id
}
