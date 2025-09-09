output "frontend_lb_arn" {
  description = "ARN of the frontend load balancer"
  value       = aws_lb.frontend.arn
}

output "frontend_lb_dns_name" {
  description = "DNS name of the frontend load balancer"
  value       = aws_lb.frontend.dns_name
}

output "frontend_target_group_arn" {
  description = "ARN of the frontend target group"
  value       = aws_lb_target_group.frontend.arn
}

output "frontend_listener_arn" {
  description = "ARN of the frontend listener"
  value       = aws_lb_listener.frontend.arn
}

output "backend_lb_arn" {
  description = "ARN of the backend load balancer"
  value       = aws_lb.backend.arn
}

output "backend_lb_dns_name" {
  description = "DNS name of the backend load balancer"
  value       = aws_lb.backend.dns_name
}

output "backend_target_group_arn" {
  description = "ARN of the backend target group"
  value       = aws_lb_target_group.backend.arn
}

output "backend_listener_arn" {
  description = "ARN of the backend listener"
  value       = aws_lb_listener.backend.arn
}
output "lb_security_group_id" {
  description = "Security group ID used by the load balancers"
  value       = var.security_group_id
}

output "lb_subnet_ids" {
  description = "Subnet IDs used by the load balancers"
  value       = var.public_subnet_ids
}
