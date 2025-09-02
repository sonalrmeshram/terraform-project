#creation of DB group
resource "aws_db_subnet_group" "group" {
    tags = {
      Name = var.aws_db_subnet_group_tag
    }
    name = var.aws_db_subnet_group_name
  description = var.aws_db_subnet_group_description
    subnet_ids = [ 
        aws_subnet.RDS-1.id,
        aws_subnet.RDS-2.id
     ]
}

#creation of RDS
    resource "aws_db_instance" "RDS" {
  identifier              = var.identifier
  engine                  = var.engine
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  skip_final_snapshot     = var.skip_final_snapshot
  publicly_accessible     = var.publicly_accessible
  storage_type = var.storage_type
  engine_version = var.engine_version

  backup_retention_period = var.backup_retention_period

  vpc_security_group_ids  = [aws_security_group.RDS.id]
  db_subnet_group_name    = aws_db_subnet_group.group.name

  tags = {
    Name = var.aws_rds_main
  }
}
