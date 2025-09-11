########################################
# Bastion EC2
########################################
resource "aws_instance" "bastion" {
  ami                         = var.ami_bastion
  instance_type               = var.instance_type
  subnet_id                   = var.bastion_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = { Name = "bastion-host" }
}

########################################
# IAM Role & Policy for Backend EC2
########################################
resource "aws_iam_role" "backend_role" {
  name = "backend-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "backend_policy" {
  name        = "backend-secrets-policy"
  description = "Allow EC2 to read backend RDS secret"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["secretsmanager:GetSecretValue","secretsmanager:DescribeSecret"],
      Resource = var.backend_secret_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.backend_policy.arn
}

resource "aws_iam_instance_profile" "backend_profile" {
  name = "backend-instance-profile"
  role = aws_iam_role.backend_role.name
}

########################################
# Backend EC2
########################################
resource "aws_instance" "backend" {
  ami                    = var.ami_backend
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_id_backend
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile   = aws_iam_instance_profile.backend_profile.name

user_data = file("${path.module}/file2.sh")

   # script runs on boot

  # Wait 5 minutes to ensure user_data script finishes
  provisioner "local-exec" {
    command = "echo 'Waiting 5 minutes for backend setup...' && sleep 300"
  }

  tags = { Name = "backend-ec2" }
}

########################################
# Frontend EC2
########################################
resource "aws_instance" "frontend" {
  ami                    = var.ami_frontend
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_id_frontend
  vpc_security_group_ids = [var.sg_id]

  user_data = file("${path.module}/file1.sh") # frontend

  # Wait 5 minutes to ensure user_data script finishes
  provisioner "local-exec" {
    command = "echo 'Waiting 5 minutes for frontend setup...' && sleep 300"
  }

  tags = { Name = "frontend-ec2" }

  depends_on = [aws_instance.backend]
}

