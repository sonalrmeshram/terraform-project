output "frontend_launch_template_id" {
  description = "ID of the frontend launch template"
  value       = aws_launch_template.frontend.id
}

output "frontend_autoscaling_group_name" {
  description = "Name of the frontend autoscaling group"
  value       = aws_autoscaling_group.frontend.name
}

output "frontend_autoscaling_group_arn" {
  description = "ARN of the frontend autoscaling group"
  value       = aws_autoscaling_group.frontend.arn
}

output "frontend_autoscaling_policy_name" {
  description = "Name of the frontend autoscaling policy"
  value       = aws_autoscaling_policy.frontend.name
}

output "backend_launch_template_id" {
  description = "ID of the backend launch template"
  value       = aws_launch_template.backend.id
}

output "backend_autoscaling_group_name" {
  description = "Name of the backend autoscaling group"
  value       = aws_autoscaling_group.backend.name
}

output "backend_autoscaling_group_arn" {
  description = "ARN of the backend autoscaling group"
  value       = aws_autoscaling_group.backend.arn
}

output "backend_autoscaling_policy_name" {
  description = "Name of the backend autoscaling policy"
  value       = aws_autoscaling_policy.backend.name
}