resource "aws_lb_target_group" "frontend" {
  tags = {
    Name = "front"
  }
  name = "front"
  protocol = "HTTP"
  port = "80"

  vpc_id = aws_vpc.project.id


}

resource "aws_lb" "frontend" {
  load_balancer_type = "application"
  name = "front"
  internal = false
  ip_address_type = "ipv4"
  subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups =[ aws_security_group.public.id ]
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