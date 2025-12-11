terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "example" {
  name_prefix = "single-instance-example-"
  description = "Security group for single instance example"
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

  # HTTP access - only if enabled and CIDR blocks provided
  dynamic "ingress" {
    for_each = var.enable_http_access && length(var.allowed_http_cidr_blocks) > 0 ? [1] : []
    content {
      description = "HTTP from allowed IPs"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_http_cidr_blocks
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "single-instance-example"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source = "../../modules/basic_instance"

  name                        = "example-single-instance"
  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = tolist(data.aws_subnets.default.ids)[0]
  security_group_ids          = [aws_security_group.example.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>Hello from EC2 instance $(hostname -f)</h1>" > /var/www/html/index.html
              systemctl start nginx
              systemctl enable nginx
              EOF

  root_volume_size      = 20
  root_volume_type      = "gp3"
  root_volume_encrypted = true

  enable_monitoring = var.enable_monitoring

  tags = {
    Environment = "dev"
    Project     = "example"
    ManagedBy   = "Terraform"
  }

  volume_tags = {
    Backup = "daily"
  }
}
