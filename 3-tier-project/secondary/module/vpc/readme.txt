1. VPC Creation
resource "aws_vpc" "project" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
      Name = var.aws_vpc_project
    }
}


Creates a VPC (your own private network in AWS).

cidr_block decides the IP range (like 172.0.0.0/16).

DNS is enabled so your instances can resolve domain names.

Tagged with a name for identification.

2. Public Subnets
resource "aws_subnet" "public_1" { ... }
resource "aws_subnet" "public_2" { ... }


Two public subnets are created inside the VPC.

Placed in different availability zones (AZs) for high availability.

Public subnets are used for things like bastion hosts or load balancers that need internet access.

3. Internet Gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.project.id
}


Allows traffic between your VPC and the internet.

Without this, nothing inside the VPC can talk to the outside world.

4. Public Route Table
resource "aws_route_table" "public" { ... }


A route table with a rule:

All traffic (0.0.0.0/0) goes to the Internet Gateway.

This makes the subnets associated with this route table public.

5. Associate Public Subnets
resource "aws_route_table_association" "public_1" { ... }
resource "aws_route_table_association" "public_2" { ... }


Connects the public subnets to the public route table.

Now any EC2 inside these subnets can access the internet.

6. Bastion Host (EC2 in Public Subnet)
resource "aws_instance" "bastion_host" { ... }


Creates an EC2 instance in public subnet 1.

Has a public IP (associate_public_ip_address = true).

Used as a bastion host to connect (SSH) into private instances securely.

7. Private Subnets
resource "aws_subnet" "private_1" { ... }
resource "aws_subnet" "private_2" { ... }
resource "aws_subnet" "private_3" { ... }
resource "aws_subnet" "private_4" { ... }


Four private subnets are created (2 per AZ).

These are meant for application servers (frontend & backend).

They cannot talk directly to the internet.

8. RDS Subnets
resource "aws_subnet" "rds_1" { ... }
resource "aws_subnet" "rds_2" { ... }


Two RDS-only subnets (for databases).

AWS RDS requires at least two subnets in different AZs for high availability.

9. Elastic IP + NAT Gateway
resource "aws_eip" "NAT" { ... }
resource "aws_nat_gateway" "NAT" { ... }


Elastic IP → a permanent public IP address.

NAT Gateway → placed in public subnet, allows private subnets to:

Access the internet (for software updates, API calls, etc.)

But still stay private (no one can connect from outside).

10. Private Route Table
resource "aws_route_table" "private" { ... }


A route table for private subnets.

All outbound traffic (0.0.0.0/0) is routed through the NAT Gateway instead of IGW.

This keeps the subnets private but still gives them internet access.

11. Associate Private Subnets
resource "aws_route_table_association" "private" {
  for_each = {
    frontend_1 = aws_subnet.private_1.id
    frontend_2 = aws_subnet.private_2.id
    backend_1  = aws_subnet.private_3.id
    backend_2  = aws_subnet.private_4.id
    rds_1      = aws_subnet.rds_1.id
    rds_2      = aws_subnet.rds_2.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}


Associates all private & RDS subnets with the private route table.

Uses for_each loop to avoid repeating the same code.

🚀 Final Architecture

VPC (your network).

2 Public Subnets → Internet access via Internet Gateway.

1 Bastion Host → Used to connect securely into private instances.

4 Private Subnets → For app servers (frontend + backend).

2 RDS Subnets → For database, isolated.

NAT Gateway → Allows private subnets to access the internet securely.

Proper Routing → Public goes via IGW, Private goes via NAT.

👉 So in short:
This code builds a secure, multi-tier AWS network with separation of:

Public layer (bastion host, LB),

Private app layer (frontend/backend),

Database layer (RDS).
