🔹 1. Public Security Group
resource "aws_security_group" "public" {
    tags = {
      Name = var.aws_security_group_public
    }
    vpc_id      = var.vpc_id
    description = var.aws_security_group_public_description

    ingress  {
        from_port   = var.ingress_port
        to_port     = var.ingress_port
        protocol    = var.ingress_protocol
        cidr_blocks = [var.security_cidr_block]
    }

    egress {
        from_port   = var.egress_port
        to_port     = var.egress_port
        protocol    = var.egress_protocol
        cidr_blocks = [var.security_cidr_block]
    }
}


Purpose: Used for resources in public subnets (like Bastion Host or Load Balancer).

Ingress (inbound): Allows traffic from the internet (cidr_blocks = 0.0.0.0/0 usually).

Example: If ingress_port = 22, this lets you SSH into the bastion host.

If ingress_port = 80, it allows HTTP traffic.

Egress (outbound): Allows all outbound traffic to the internet.

🔹 2. Private Security Group
resource "aws_security_group" "private" {
    tags = {
      Name = var.aws_security_group_private
    }
    description = var.description
    vpc_id      = var.vpc_id

    ingress {
        from_port   = var.ingress_port
        to_port     = var.ingress_port
        protocol    = var.ingress_protocol
        cidr_blocks = [ var.security_cidr_block ]
    }

    egress {
        from_port   = var.egress_port
        to_port     = var.egress_port
        protocol    = var.egress_protocol
        cidr_blocks = [ var.security_cidr_block ]
    }
}


Purpose: For EC2 instances in private subnets (frontend/backend servers).

Typically, instead of opening to the whole internet, this SG should allow traffic only from the Public SG (bastion or LB).

Right now, it’s wide open (same CIDR as public). In production, you’d want to restrict it:

Example: Allow only Bastion Host (SSH) or only Load Balancer (HTTP/HTTPS).

🔹 3. RDS Security Group
resource "aws_security_group" "RDS" {
  name        = var.aws_security_group_RDS
  description = var.aws_security_group_rds_description
  vpc_id      = var.vpc_id

  ingress {
      from_port   = var.ingress_port
      to_port     = var.ingress_port
      protocol    = var.ingress_protocol
      cidr_blocks = [var.security_cidr_block]
  }

  egress {
      from_port   = var.egress_port
      to_port     = var.egress_port
      protocol    = var.egress_protocol
      cidr_blocks = [var.security_cidr_block]
  }
}


Purpose: Protects your RDS database.

Normally, you do NOT expose RDS to the internet.

Instead, you allow inbound only from the Private SG (so only app servers can talk to DB).

Right now, it’s too open because it allows cidr_blocks = 0.0.0.0/0.
👉 In a real setup:

ingress {
  from_port       = 3306  # MySQL default
  to_port         = 3306
  protocol        = "tcp"
  security_groups = [aws_security_group.private.id] # only private EC2 can connect
}

✅ Flow with Your SGs

Public SG → Allows internet access (e.g., SSH or HTTP).

Attached to Bastion Host or Load Balancer.

Private SG → Allows internal traffic.

Attached to App servers (Frontend/Backend).

Ideally should only accept requests from Public SG.

RDS SG → Protects database.

Attached to RDS.

Should only accept requests from Private SG (app servers).
