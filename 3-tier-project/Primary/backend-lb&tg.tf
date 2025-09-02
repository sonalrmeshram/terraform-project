resource "aws_lb_target_group" "backend" {
  tags = {
    Name = "back"
  }
  name = "back"
  protocol = "HTTP"
  port = "80"
  vpc_id = aws_vpc.project.id

}

resource "aws_lb" "backend" {
  load_balancer_type = "application"
  name = "back"
  internal = false
  ip_address_type = "ipv4"
  subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups =[ aws_security_group.public.id ]

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