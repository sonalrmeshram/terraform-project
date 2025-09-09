output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.project.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
    aws_subnet.private_3.id,
    aws_subnet.private_4.id
  ]
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

output "bastion_instance_id" {
  description = "ID of the bastion host EC2 instance"
  value       = aws_instance.bastion_host.id
}

