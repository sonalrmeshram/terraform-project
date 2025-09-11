output "public_sg_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public.id
}

output "private_sg_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private.id
}

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.RDS.id
}