output "rds_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.RDS.id
}

output "rds_endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.RDS.endpoint
}

output "rds_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.group.name
}

output "rds_subnet_group_id" {
  description = "ID of the DB subnet group"
  value       = aws_db_subnet_group.group.id
}

output "rds_security_group_id" {
  description = "Security group ID used by the RDS instance"
  value       = var.security_group_rds_id
}


output "rds_engine" {
  description = "Engine used by the RDS instance"
  value       = aws_db_instance.RDS.engine
}

output "rds_db_name" {
  description = "Name of the database created"
  value       = aws_db_instance.RDS.db_name
}