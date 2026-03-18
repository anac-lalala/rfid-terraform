locals {
  raw_name_prefix = "${var.project_name}-${var.environment}"
  name_prefix     = lower(replace(local.raw_name_prefix, " ", "-"))

  tags = merge(
    var.common_tags,
    {
      NamePrefix = local.name_prefix
    }
  )
}

# -----------------------------------
# VPC
# -----------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# -----------------------------------
# Public Subnets
# -----------------------------------
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public-${count.index + 1}"
    Tier = "public"
  })
}

# -----------------------------------
# Front Subnets
# -----------------------------------
resource "aws_subnet" "front" {
  count = length(var.front_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.front_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-front-${count.index + 1}"
    Tier = "front"
  })
}

# -----------------------------------
# Back Subnets
# -----------------------------------
resource "aws_subnet" "back" {
  count = length(var.back_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.back_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-back-${count.index + 1}"
    Tier = "back"
  })
}

# -----------------------------------
# DB Subnets
# -----------------------------------
resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-db-${count.index + 1}"
    Tier = "db"
  })
}

# -----------------------------------
# Route Tables
# -----------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "front_private" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-front-private-rt"
  })
}

resource "aws_route_table_association" "front" {
  count = length(aws_subnet.front)

  subnet_id      = aws_subnet.front[count.index].id
  route_table_id = aws_route_table.front_private.id
}

resource "aws_route_table" "back_private" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-back-private-rt"
  })
}

resource "aws_route_table_association" "back" {
  count = length(aws_subnet.back)

  subnet_id      = aws_subnet.back[count.index].id
  route_table_id = aws_route_table.back_private.id
}

resource "aws_route_table" "db_private" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-db-private-rt"
  })
}

resource "aws_route_table_association" "db" {
  count = length(aws_subnet.db)

  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db_private.id
}

# -----------------------------------
# DB Subnet Group
# -----------------------------------
resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = aws_subnet.db[*].id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}