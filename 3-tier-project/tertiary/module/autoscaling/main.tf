##################################
# Create AMIs from source instances
##################################

resource "aws_ami_from_instance" "frontend" {
  name               = "frontend"
  source_instance_id = var.source_frontend
  description        = "AMI created from instance ${var.source_frontend}"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "frontend"
    Environment = var.environment
  }

  
}

resource "aws_ami_from_instance" "backend" {
  name               = "backend"
  source_instance_id = var.source_backend
  description        = "AMI created from instance ${var.source_backend}"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "backend"
    Environment = var.environment
  }

}

##################################
# Launch Templates
##################################

resource "aws_launch_template" "frontend" {
  name                   = "frontend-template"
  image_id               = aws_ami_from_instance.frontend.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "frontend"
    }
  }
}

resource "aws_launch_template" "backend" {
  name                   = "backend-template"
  image_id               = aws_ami_from_instance.backend.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "backend"
    }
  }
}

##################################
# Auto Scaling Groups
##################################

resource "aws_autoscaling_group" "frontend" {
  name_prefix         = "frontend-asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = var.private_subnet_ids_frontend
  target_group_arns   = [var.frontend_lb_target_group_arn]

  health_check_type = "ELB" # better for ALB integration

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["desired_capacity"]
  }

  tag {
    key                 = "Name"
    value               = "frontend"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "backend" {
  name_prefix         = "backend-asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = var.private_subnet_ids_backend
  target_group_arns   = [var.backend_lb_target_group_arn]

  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["desired_capacity"]
  }

  tag {
    key                 = "Name"
    value               = "backend"
    propagate_at_launch = true
  }
}

##################################
# Scaling Policies
##################################

resource "aws_autoscaling_policy" "frontend" {
  name                   = "frontend-policy"
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value     = var.scale_out_target_value
    disable_scale_in = false
  }
}

resource "aws_autoscaling_policy" "backend" {
  name                   = "backend-policy"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value     = var.scale_out_target_value
    disable_scale_in = false
  }
}
