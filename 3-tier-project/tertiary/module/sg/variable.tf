variable "vpc_id" {
  type        = string
  description = "ID of the VPC where security groups will be created"
}

variable "aws_security_group_public" {
  type        = string
  description = "Name tag for the public security group"
}

variable "aws_security_group_public_description" {
  type        = string
  description = "Description for the public security group"
}

variable "aws_security_group_private" {
  type        = string
  description = "Name tag for the private security group"
}

variable "description" {
  type        = string
  description = "Description for the private security group"
}

variable "aws_security_group_RDS" {
  type        = string
  description = "Name tag for the RDS security group"
}

variable "aws_security_group_rds_description" {
  type        = string
  description = "Description for the RDS security group"
}

variable "ingress_port" {
  type        = number
  description = "Ingress port to allow (e.g., 22 for SSH)"
}

variable "egress_port" {
  type        = number
  description = "Egress port to allow (usually 0 for all)"
}

variable "ingress_protocol" {
  type        = string
  description = "Protocol for ingress rules (e.g., tcp)"
}

variable "egress_protocol" {
  type        = string
  description = "Protocol for egress rules (e.g., -1 for all)"
}

variable "security_cidr_block" {
  type        = string
  description = "CIDR block to allow traffic from/to (e.g., 0.0.0.0/0)"
}