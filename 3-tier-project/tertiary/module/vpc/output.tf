output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.project.id
}



output "private_1" {
  value = aws_subnet.private_1.id
}
output "private_2" {
  value = aws_subnet.private_2.id
}
output "private_3" {
  value = aws_subnet.private_3.id
}
output "private_4" {
  value = aws_subnet.private_4.id
}
output "rds_1" {
  value = aws_subnet.rds_1.id
}
output "rds_2" {
  value = aws_subnet.rds_2.id
}
output "public_1" {
  value = aws_subnet.public_1.id
}
output "public_2" {
  value = aws_subnet.public_2.id
}


output "rds_subnet_ids" {
  description = "IDs of the RDS subnets"
  value       = [
    aws_subnet.rds_1.id,
    aws_subnet.rds_2.id
  ]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.name.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.NAT.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}



