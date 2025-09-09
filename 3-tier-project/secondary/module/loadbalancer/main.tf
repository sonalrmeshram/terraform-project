resource "aws_lb_target_group" "frontend" {
  tags = {
    Name = "front"
  }
  name = "front"
  protocol = "HTTP"
  port = "80"

  vpc_id = var.vpc_id
    health_check {
    protocol = "HTTP"
    path     = "/"       # simple root check
    matcher  = "200"
  }
}

resource "aws_lb" "frontend" {
  load_balancer_type = "application"
  name = "front"
  internal = false
  ip_address_type = "ipv4"
  subnets         = var.public_subnet_ids
  security_groups = [var.security_group_id]
  tags = {
    Name = "front"
  }
  
}
 
resource "aws_lb_listener" "frontend" {
  protocol = "HTTP"
  port = "80"
  load_balancer_arn = aws_lb.frontend.arn
  default_action {
    target_group_arn = aws_lb_target_group.frontend.arn
    type = "forward"
  }
  depends_on =[aws_lb_target_group.frontend ]

}
resource "aws_lb_target_group" "backend" {
  tags = {
    Name = "back"
  }
  name = "back"
  protocol = "HTTP"
  port = "80"
  vpc_id = var.vpc_id
    health_check {
    protocol = "HTTP"
    path     = "/"       # simple root check
    matcher  = "200"
  }

}

resource "aws_lb" "backend" {
  load_balancer_type = "application"
  name = "back"
  internal = false
  ip_address_type = "ipv4"
  subnets = var.public_subnet_ids
  security_groups    = [var.security_group_id]

   depends_on = [aws_lb_target_group.backend]
}

resource "aws_lb_listener" "backend" {
  protocol = "HTTP"
  port = "80"
  load_balancer_arn = aws_lb.backend.arn

  default_action {
    target_group_arn = aws_lb_target_group.backend.arn
    type = "forward"
  }
  depends_on = [aws_lb_target_group.backend]
}