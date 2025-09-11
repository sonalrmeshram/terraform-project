output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Public IP of Bastion host"
}

output "backend_private_ip" {
  value       = aws_instance.backend.private_ip
  description = "Private IP of Backend EC2"
}

output "frontend_private_ip" {
  value       = aws_instance.frontend.private_ip
  description = "Private IP of Frontend EC2"
}

output "backend_instance_id" {
  value       = aws_instance.backend.id
  description = "Instance ID of Backend EC2"
}

output "frontend_instance_id" {
  value       = aws_instance.frontend.id
  description = "Instance ID of Frontend EC2"
}

output "backend_instance_profile" {
  value       = aws_iam_instance_profile.backend_profile.name
  description = "IAM Instance Profile used by Backend EC2"
}
output "bastion_instance_id" {
  description = "ID of the bastion host EC2 instance"
  value       = aws_instance.bastion.id
}