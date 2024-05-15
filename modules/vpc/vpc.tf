resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames
  tags = {
    "Name" = "vpc-${var.sufix}"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet-${each.key}-${var.sufix}"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    "Name" = "private_subnet-${each.key}-${var.sufix}"
  }
  depends_on = [
    aws_subnet.public_subnet
  ]
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw vpc virginia-${var.sufix}"
  }
}


resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "crt-public-${var.sufix}"
  }
}

resource "aws_route_table" "private_crt" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = "crt-private-${each.key}-${var.sufix}"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_route_table_association" "crta_private_subnet" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_crt[each.key].id
}

# NATGW

resource "aws_eip" "eips" {
  count      = var.natgw ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "eip-${count.index}-${var.sufix}"
  }
}

locals {
  map_keys     = keys(aws_subnet.public_subnet)
  first_subnet = element(local.map_keys, 0)
}
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.natgw ? 1 : 0
  allocation_id = aws_eip.eips[count.index].id
  subnet_id     = aws_subnet.public_subnet[local.first_subnet].id
  depends_on    = [aws_internet_gateway.igw, aws_eip.eips]
  tags = {
    Name = "ngw-${count.index}-${var.sufix}"
  }
}

resource "aws_route" "private_sunets_internet_route" {
  for_each               = var.natgw == true ? var.private_subnets : {}
  route_table_id         = aws_route_table.private_crt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[0].id
}


data "aws_region" "current" {}
resource "aws_vpc_endpoint" "s3" {
  count             = var.s3_endpoint_enable ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "s3_endpoint-${count.index}-${var.sufix}"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3_endpoint_private_crts" {
  for_each        = var.s3_endpoint_enable == true ? var.private_subnets : {}
  route_table_id  = aws_route_table.private_crt[each.key].id
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}

resource "aws_vpc_endpoint" "dynamodb" {
  count             = var.dynamodb_endpoint_enable ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "dynamodb_endpoint-${count.index}-${var.sufix}"
  }
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_endpoint_private_crts" {
  for_each        = var.dynamodb_endpoint_enable == true ? var.private_subnets : {}
  route_table_id  = aws_route_table.private_crt[each.key].id
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
}
