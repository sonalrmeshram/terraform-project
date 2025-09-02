#security group creation
resource "aws_security_group" "public" {
    tags = {
      Name = var.aws_security_group_public
    }
    vpc_id = aws_vpc.project.id
    description = var.aws_security_group_public_description
    ingress  {
        from_port = var.ingress_port
        to_port = var.ingress_port
        protocol = var.ingress_protocol
        cidr_blocks = [var.security_cidr_block]
    }
    egress {
        from_port = var.egress_port
        to_port = var.egress_port
        protocol = var.egress_protocol #all protocol
        cidr_blocks = [var.security_cidr_block]
    }
  
}

#private security group
resource "aws_security_group" "private" {
    tags = {
      Name = var.aws_security_group_private
      
    }
    description = var.description
    vpc_id = aws_vpc.project.id
    ingress{
        from_port = var.ingress_port
        to_port = var.ingress_port
        protocol = var.ingress_protocol
        cidr_blocks = [ var.security_cidr_block ]
    }
    egress {
        from_port = var.egress_port
        to_port = var.egress_port
        protocol = var.egress_protocol #all protocol
        cidr_blocks = [ var.security_cidr_block]
    }
}


#creation of security group
resource "aws_security_group" "RDS" {
  name = var.aws_security_group_RDS
  description = var.aws_security_group_rds_description
  vpc_id = aws_vpc.project.id

    ingress  {
        from_port = var.ingress_port
        to_port = var.ingress_port
        protocol = var.ingress_protocol
        cidr_blocks = [var.security_cidr_block]
    }
    egress {
        from_port = var.egress_port
        to_port = var.egress_port
        protocol = var.egress_protocol #all protocol
        cidr_blocks = [var.security_cidr_block]
    }
}
