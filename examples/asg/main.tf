terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source for default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source for default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for ASG instances
resource "aws_security_group" "asg" {
  name_prefix = "${var.project}-${var.environment}-asg-"
  description = "Security group for ASG instances"
  vpc_id      = data.aws_vpc.default.id

  # SSH access - only if enabled and CIDR blocks provided
  dynamic "ingress" {
    for_each = var.enable_ssh_access && length(var.allowed_ssh_cidr_blocks) > 0 ? [1] : []
    content {
      description = "SSH from allowed IPs"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidr_blocks
    }
  }

  # HTTP access - only if CIDR blocks provided
  dynamic "ingress" {
    for_each = length(var.allowed_http_cidr_blocks) > 0 ? [1] : []
    content {
      description = "HTTP from allowed IPs"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_http_cidr_blocks
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-asg-sg"
    Environment = var.environment
    Project     = var.project
  }
}

# ASG module
module "asg" {
  source = "../../modules/asg"

  name = "${var.project}-${var.environment}-asg"

  # Launch template configuration
  ami_id             = data.aws_ami.amazon_linux_2.id
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_ids = [aws_security_group.asg.id]
  user_data          = var.user_data
  enable_monitoring  = true

  # ASG configuration
  subnet_ids                = data.aws_subnets.default.ids
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Scaling policies
  enable_scaling_policies = true
  cpu_high_threshold      = 70
  cpu_low_threshold       = 20

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}
