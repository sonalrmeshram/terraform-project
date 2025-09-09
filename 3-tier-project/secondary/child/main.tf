######################################################
# VPC Module
######################################################
module "vpc" {
  source = "../module/vpc"

  vpc_cidr_block            = "10.0.0.0/16"
  aws_vpc_project           = "Project"

  # Public subnets
  cidr_block_public_1       = "10.0.1.0/24"
  availability_zone_1       = "us-east-1a"
  aws_subnet_public_1       = "bastion"

  cidr_block_public_2       = "10.0.2.0/24"
  availability_zone_2       = "us-east-1b"
  aws_subnet_public_2       = "public"

  aws_internet_gateway      = "IGW"
  aws_route_table_public    = "public"
  route_cidr_block          = "0.0.0.0/0"

  # Bastion host
  aws_instance_public_1     = "bastion"
  ami                       = "ami-084a7d336e816906b"
  instance_type             = "t2.micro"
  key_name                  = "b"
  vpc_security_group_id     = module.SG.public_sg_id

  # Private subnets
  cidr_block_private_1      = "10.0.11.0/24"
  aws_subnet_private_1      = "frontend_1"

  cidr_block_private_2      = "10.0.12.0/24"
  aws_subnet_private_2      = "frontend_2"

  cidr_block_private_3      = "10.0.21.0/24"
  aws_subnet_private_3      = "backend_1"

  cidr_block_private_4      = "10.0.22.0/24"
  aws_subnet_private_4      = "backend_2"

  # RDS subnets
  cidr_block_rds_1          = "10.0.31.0/24"
  aws_subnet_rds_1          = "rds_1"

  cidr_block_rds_2          = "10.0.32.0/24"
  aws_subnet_rds_2          = "rds_2"

  # NAT
  aws_nat_name              = "NAT"
  aws_connectivity          = "public"
  aws_route_table_private   = "private"
}

######################################################
# Security Group Module
######################################################
module "SG" {
  source = "../module/SG"

  vpc_id                             = module.vpc.vpc_id
  aws_security_group_public          = "public-sg"
  aws_security_group_public_description = "Allow SSH and HTTP from anywhere"

  aws_security_group_private         = "private-sg"
  description                        = "Allow internal traffic only"

  aws_security_group_RDS             = "rds-sg"
  aws_security_group_rds_description = "Allow DB access from backend"

  ingress_port                       = 0
  ingress_protocol                   = "-1"
  egress_port                        = 0
  egress_protocol                    = "-1"
  security_cidr_block                = "0.0.0.0/0"
}

######################################################
# RDS Module
######################################################
module "rds" {
  source = "../module/rds"

  aws_db_subnet_group_tag        = "rds-subnet-group"
  aws_db_subnet_group_name       = "rds-subnet-group"
  aws_db_subnet_group_description = "RDS subnet group"

  identifier                     = "mydb"
  engine                         = "mysql"
  engine_version                 = "8.0"
  instance_class                 = "db.t3.micro"
  allocated_storage              = 20
   db_name                       = "rds"
  username                       = "admin"
  password                       = "Sonal45815"
  skip_final_snapshot            = true
  publicly_accessible            = false
  storage_type                   = "gp2"
  backup_retention_period        = 7
  aws_rds_main                   = "my-rds"

  security_group_rds_id          = module.SG.rds_sg_id
  subnet_ids                     = module.vpc.rds_subnet_ids
}

######################################################
# Load Balancer Module
######################################################
module "loadbalancer" {
  source = "../module/loadbalancer"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  security_group_id      = module.SG.public_sg_id

  frontend_lb_name       = "frontend-lb"
  backend_lb_name        = "backend-lb"
  frontend_target_group_name = "frontend-tg"
  backend_target_group_name  = "backend-tg"
  listener_port          = 80
  listener_protocol      = "HTTP"
}

######################################################
# Auto Scaling Module
######################################################
module "autoscaling" {
  source = "../module/autoscaling"

  frontend_ami                 = "front"
  backend_ami                  = "back"
  key_name                     = "b"
  vpc_id                        = module.vpc.vpc_id

  private_subnet_ids_frontend   = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1]]
  private_subnet_ids_backend    = [module.vpc.private_subnet_ids[2], module.vpc.private_subnet_ids[3]]

  security_group_id             = module.SG.private_sg_id
  scale_out_target_value        = 50

  # Provide ALB target groups
  frontend_lb_target_group_arn  = module.loadbalancer.frontend_target_group_arn
  backend_lb_target_group_arn   = module.loadbalancer.backend_target_group_arn
}
