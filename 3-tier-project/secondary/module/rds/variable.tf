variable "aws_db_subnet_group_tag" {
  type        = string
  description = "Name tag for the DB subnet group"
}

variable "aws_db_subnet_group_name" {
  type        = string
  description = "Name of the DB subnet group"
}

variable "aws_db_subnet_group_description" {
  type        = string
  description = "Description for the DB subnet group"
}

variable "identifier" {
  type        = string
  description = "Unique identifier for the RDS instance"
}

variable "engine" {
  type        = string
  description = "Database engine (e.g., mysql, postgres)"
}

variable "engine_version" {
  type        = string
  description = "Version of the database engine"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class (e.g., db.t3.micro)"
}

variable "allocated_storage" {
  type        = number
  description = "Storage size in GB"
}

variable "db_name" {
  type        = string
  description = "Name of the initial database to create"
}

variable "username" {
  type        = string
  description = "Master username for the database"
}

variable "password" {
  type        = string
  description = "Master password for the database"
  sensitive   = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Whether to skip final snapshot on deletion"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether the RDS instance is publicly accessible"
}

variable "storage_type" {
  type        = string
  description = "Type of storage (e.g., gp2, io1)"
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain backups"
}

variable "aws_rds_main" {
  type        = string
  description = "Name tag for the RDS instance"
}

variable "security_group_rds_id" {
  type        = string
  description = "ID of the RDS security group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the DB subnet group"
}