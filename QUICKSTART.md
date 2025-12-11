# Quick Start Guide - Using This Module in Your Project

This guide shows how to use the terraform-aws-compute-ec2 module in your own Terraform projects.

## Prerequisites

- Terraform >= 1.0 installed
- AWS CLI configured with credentials
- An AWS account with appropriate permissions
- Basic understanding of Terraform and AWS EC2

## Security First

**IMPORTANT:** The examples in this module have security groups disabled by default. You must explicitly enable and configure access. Never use `0.0.0.0/0` for SSH access!

### Get Your Public IP
```bash
curl -s https://checkip.amazonaws.com
```

### Security Best Practices
1. **SSH Access**: Always restrict to specific IP addresses, never `0.0.0.0/0`
2. **HTTP/HTTPS**: Use `0.0.0.0/0` only for public web servers
3. **Production**: Use AWS Systems Manager Session Manager instead of SSH
4. **Load Balancers**: Restrict instance access to load balancer security groups
5. **Bastion Hosts**: Use bastion/jump hosts for accessing private instances

## Step 1: Create Your Project Directory

```bash
mkdir my-terraform-project
cd my-terraform-project
```

## Step 2: Create Terraform Configuration Files

### main.tf

```hcl
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

# Basic EC2 Instance
module "web_server" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/basic_instance"

  name               = "${var.project_name}-web"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = var.subnet_id
  security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Security Group
resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-web-"
  description = "Security group for web server"
  vpc_id      = var.vpc_id

  # HTTP access - adjust based on your needs
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Public web server - use carefully!
  }

  # SSH access - ALWAYS restrict to your IP!
  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  # NEVER use 0.0.0.0/0 for SSH!
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-web-sg"
    Environment = var.environment
  }
}
```

### variables.tf

```hcl
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance (Amazon Linux 2 in us-east-1)"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "my_ip" {
  description = "Your IP address for SSH access (CIDR format)"
  type        = string
}
```

### outputs.tf

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.web_server.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = module.web_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the instance"
  value       = module.web_server.private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web.id
}

output "web_url" {
  description = "URL to access the web server"
  value       = "http://${module.web_server.public_ip}"
}
```

### terraform.tfvars

Create this file with your specific values:

```hcl
aws_region    = "us-east-1"
project_name  = "myapp"
environment   = "dev"
ami_id        = "ami-0c55b159cbfafe1f0"  # Update with current AMI
instance_type = "t3.micro"
vpc_id        = "vpc-xxxxx"              # Your VPC ID
subnet_id     = "subnet-xxxxx"           # Your subnet ID
my_ip         = "1.2.3.4/32"            # Your IP address
```

## Step 3: Initialize and Deploy

```bash
# Initialize Terraform (downloads providers and modules)
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

## Step 4: Access Your Instance

After deployment completes, Terraform will output the instance details:

```bash
# Get the public IP
terraform output instance_public_ip

# Access the web server
curl http://$(terraform output -raw instance_public_ip)

# SSH into the instance (if you have the key)
ssh -i ~/.ssh/your-key.pem ec2-user@$(terraform output -raw instance_public_ip)
```

## Step 5: Clean Up

When you're done, destroy the resources:

```bash
terraform destroy
```

## Using Different Module Types

### Auto Scaling Group

```hcl
module "app_asg" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/asg"

  name                = "${var.project_name}-asg"
  ami_id              = var.ami_id
  instance_type       = "t3.micro"
  security_group_ids  = [aws_security_group.app.id]
  subnet_ids          = var.subnet_ids

  min_size            = 2
  max_size            = 10
  desired_capacity    = 3

  health_check_type   = "EC2"
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
```

### Advanced Instance

```hcl
module "database_server" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/advanced_instance"

  name                = "${var.project_name}-db"
  ami_id              = var.ami_id
  instance_type       = "t3.medium"
  subnet_id           = var.private_subnet_id
  security_group_ids  = [aws_security_group.db.id]

  iam_instance_profile = aws_iam_instance_profile.db.name

  ebs_volumes = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 100
      iops        = 3000
      encrypted   = true
    }
  ]

  enable_detailed_monitoring = true

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Role        = "database"
  }
}
```

## Version Pinning

For production, always pin to a specific release:

```hcl
module "ec2" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/basic_instance?ref=v1.0.0"
  # configuration...
}
```

## Finding Your AWS Resources

### Get VPC and Subnet IDs

```bash
# List VPCs
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0]]' --output table

# List Subnets in a VPC
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxxxx" --query 'Subnets[*].[SubnetId,AvailabilityZone,CidrBlock]' --output table

# Get latest Amazon Linux 2 AMI
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query 'sort_by(Images, &CreationDate)[-1].[ImageId,Name]' --output table

# Get your public IP
curl -s https://checkip.amazonaws.com
```

## Troubleshooting

### Module Not Found
If you get "module not found", ensure:
- You have internet access
- GitHub is accessible
- The module path includes `//modules/MODULE_NAME`

### Authentication Errors
- Verify AWS credentials: `aws sts get-caller-identity`
- Check AWS region is correct
- Ensure IAM permissions for EC2, VPC, etc.

### Instance Won't Start
- Verify AMI ID is valid for your region
- Check subnet has available IP addresses
- Ensure security group allows required traffic

## Next Steps

1. Review the [main README](README.md) for detailed module documentation
2. Check the [examples](examples/) directory for more complex setups
3. Read module-specific READMEs:
   - [basic_instance](modules/basic_instance/README.md)
   - [asg](modules/asg/README.md)
   - [advanced_instance](modules/advanced_instance/README.md)

## Support

For issues or questions:
- Open an issue on GitHub
- Review existing examples
- Check AWS documentation for resource-specific questions
