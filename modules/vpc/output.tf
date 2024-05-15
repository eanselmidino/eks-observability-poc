output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = tolist(values(aws_subnet.public_subnet)[*].id)
}

output "private_subnets" {
  value = tolist(values(aws_subnet.private_subnet)[*].id)
}

output "private_route_tables" {
  value = tolist(values(aws_route_table.private_crt)[*].id)
}

output "natgw_id" {
  value = var.natgw ? aws_nat_gateway.nat_gateway[0].id : null
}

