data "aws_ami" "backend" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.backend_ami]
  }
}
resource "aws_launch_template" "backend" {
  name = "back"
  image_id = data.aws_ami.backend.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name = var.key_name
  
  tag_specifications {
    resource_type = "instance"
    tags = {
    Name = "back"
  }
}
}

resource "aws_autoscaling_group" "backend" {
  name_prefix = "back"
  min_size = 1
  max_size = 2
  desired_capacity = 1
  vpc_zone_identifier = [ aws_subnet.private_3.id, aws_subnet.private_4.id ]
  target_group_arns = [ aws_lb_target_group.backend.arn ]
  health_check_type = "EC2"

  launch_template {
    id = aws_launch_template.backend.id
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
    value = "back"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_policy" "backend" {
  name = "back"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
   predefined_metric_specification {
  predefined_metric_type = "ASGAverageCPUUtilization"
}
    target_value = var.scale_out_target_value
    disable_scale_in = false
  }

}