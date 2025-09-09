variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the load balancers will be deployed"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the load balancers"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID to associate with the load balancers"
}

variable "frontend_lb_name" {
  type        = string
  description = "Name of the frontend load balancer"
  default     = "front"
}

variable "backend_lb_name" {
  type        = string
  description = "Name of the backend load balancer"
  default     = "back"
}

variable "frontend_target_group_name" {
  type        = string
  description = "Name of the frontend target group"
  default     = "front"
}

variable "backend_target_group_name" {
  type        = string
  description = "Name of the backend target group"
  default     = "back"
}

variable "listener_port" {
  type        = number
  description = "Port for the ALB listeners"
  default     = 80
}

variable "listener_protocol" {
  type        = string
  description = "Protocol for the ALB listeners"
  default     = "HTTP"
}

