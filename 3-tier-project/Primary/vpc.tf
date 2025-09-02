#vpc creation
resource "aws_vpc" "project" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support =  true
    tags = {
      Name = var.aws_vpc_project
       
    }
  
}
#subnet creation
resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.project.id
    cidr_block = var.cidr_block_public_1
    availability_zone = var.availability_zone_1
    tags = {
      Name = var.aws_subnet_public_1
    }
}
resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.project.id
    cidr_block = var.cidr_block_public_2
    availability_zone = var.availability_zone_2
    tags = {
      Name = var.aws_subnet_public_2
    }
}

#internet gateway creation and attach to vpc
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.project.id
  tags = {
    Name= var.aws_internet_gateway
  }
}
#create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.project.id
  tags = {
    Name= var.aws_route_table_public
  }
  route {
    cidr_block=var.route_cidr_block
    gateway_id = aws_internet_gateway.name.id
  }
}
#subnet Association
resource "aws_route_table_association" "public_1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_2" {
    subnet_id = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
}

#create public server
resource "aws_instance" "bastion_host" {
    tags = {
      Name = var.aws_instance_public_1
    }
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.public.id]
  associate_public_ip_address = true
  key_name               = var.key_name
}


#create private subnet
resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.project.id
  cidr_block = var.cidr_block_private_1
  availability_zone = var.availability_zone_1
  tags = {
    Name = var.aws_subnet_private_1
  }
}
resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.project.id
  cidr_block = var.cidr_block_private_2
  availability_zone = var.availability_zone_2
  tags = {
    Name = var.aws_subnet_private_2
  }
}
resource "aws_subnet" "private_3" {
  vpc_id = aws_vpc.project.id
  cidr_block = var.cidr_block_private_3
  availability_zone = var.availability_zone_1
  tags = {
    Name = var.aws_subnet_private_3
  }
}
resource "aws_subnet" "private_4" {
  vpc_id = aws_vpc.project.id
  cidr_block = var.cidr_block_private_4
  availability_zone = var.availability_zone_2
  tags = {
    Name = var.aws_subnet_private_4
  }
}


#create private subnet
resource "aws_subnet" "RDS-1" {
  vpc_id = aws_vpc.project.id
  cidr_block = var.cidr_block_rds_1
  availability_zone = var.availability_zone_1
    tags = {
    Name = var.aws_subnet_rds_1
  }
}

#create private subnet
resource "aws_subnet" "RDS-2" {
  vpc_id = aws_vpc.project.id
  cidr_block = var.cidr_block_rds_2
  availability_zone = var.availability_zone_2
    tags = {
    Name = var.aws_subnet_rds_2
  }
}

# creation of elastic IP
resource "aws_eip" "NAT" {
  tags = {
    Name = var.aws_nat_name
  }
}

#creation of NaT
resource "aws_nat_gateway" "NAT" {
  tags = {
    Name= var.aws_nat_name
  }
  subnet_id = aws_subnet.public_1.id
  connectivity_type = var.aws_connectivity
  allocation_id = aws_eip.NAT.id
}

#create route table and route
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.project.id
  tags = {
    Name = var.aws_route_table_private
  }
  route {
    cidr_block = var.route_cidr_block
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
}

resource "aws_route_table_association" "private" {
  for_each = {
    frontend_1 = aws_subnet.private_1.id
    frontend_2 = aws_subnet.private_2.id
    backend_1  = aws_subnet.private_3.id
    backend_2  = aws_subnet.private_4.id
    rds_1      = aws_subnet.RDS-1.id
    rds_2      = aws_subnet.RDS-2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}