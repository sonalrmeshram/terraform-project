

variable "key_name" {
  type        = string
  description = "Name of the key pair to use for EC2 instances"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC for the launch templates"
}

variable "private_subnet_ids_frontend" {
  type        = list(string)
  description = "List of private subnet IDs for the frontend autoscaling group"
}

variable "private_subnet_ids_backend" {
  type        = list(string)
  description = "List of private subnet IDs for the backend autoscaling group"
}


variable "security_group_id" {
  type        = string
  description = "ID of the security group to associate with EC2 instances"
}

variable "scale_out_target_value" {
  type        = number
  description = "Target CPU utilization for autoscaling"
  default     = 50
}

variable "frontend_lb_target_group_arn" {
  type        = string
  description = "ARN of the frontend target group for ASG"
}

variable "backend_lb_target_group_arn" {
  type        = string
  description = "ARN of the backend target group for ASG"
}

variable "source_frontend" {
  type        = string
  description = "ID of the existing instance to create frontend AMI from"
}

variable "source_backend" {
  type        = string
  description = "ID of the existing instance to create backend AMI from"
}

variable "environment" {
  type        = string
  description = "dev"
}
