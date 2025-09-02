output "frontend_alb_dns" {
  value = aws_lb.frontend.dns_name
}
output "backend_alb_dns" {
  value = aws_lb.backend.dns_name
}
output "rds_endpoint" {
  value = aws_db_instance.RDS.endpoint
}
output "db_instance_id" {
  value = aws_db_instance.RDS.id
}
output "bastion_instance_id" {
  value = aws_instance.bastion_host.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.bastion_host.private_ip
}
output "alb_arn" {
  value = aws_lb.frontend.arn
}

output "alb_dns_name" {
  value = aws_lb.frontend.dns_name
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.frontend.arn
}

