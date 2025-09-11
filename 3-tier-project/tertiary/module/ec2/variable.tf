variable "ami_frontend" {
  type        = string
  description = "AMI ID for frontend EC2"
}

variable "ami_backend" {
  type        = string
  description = "AMI ID for backend EC2"
}

variable "ami_bastion" {
  type        = string
  description = "AMI ID for bastion EC2"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "Key pair name for SSH"
}

variable "bastion_subnet_id" {
  type        = string
}

variable "private_subnet_id_frontend" {
  type        = string
}
variable "private_subnet_id_backend" {
  
}

variable "sg_id" {
  type        = string
  description = "Security group ID for private EC2s"
}

variable "bastion_sg_id" {
  type        = string
  description = "Security group ID for bastion host"
}

variable "backend_secret_arn" {
  type        = string
  description = "ARN of backend secret in Secrets Manager"
}

variable "frontend_script_path" {
  type        = string
}

variable "backend_script_path" {
  type        = string
}
