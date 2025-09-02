data "aws_ami" "frontend" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"  # lowercase 'name'
    values = [var.frontend_ami]  # Ensure this matches your AMI name exactly
  }
}
resource "aws_launch_template" "frontend" {
  name = "front"
  image_id = data.aws_ami.frontend.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name = "b"
  
  tag_specifications {
    resource_type = "instance"
    tags = {
    Name = "front"
  }
}
}

resource "aws_autoscaling_group" "frontend" {
  name_prefix = "front"
  min_size = 1
  max_size = 2
  desired_capacity = 1
  vpc_zone_identifier = [ aws_subnet.private_1.id, aws_subnet.private_2.id ]
  target_group_arns = [ aws_lb_target_group.frontend.arn ]
  health_check_type = "EC2"

  launch_template {
    id = aws_launch_template.frontend.id
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
    key = "Name"
    value = "front"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "frontend" {
  name = "front"
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
  predefined_metric_type = "ASGAverageCPUUtilization"
}
    target_value = var.scale_out_target_value
    disable_scale_in = false
  }

}