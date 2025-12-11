# Terraform AWS Compute EC2

A comprehensive Terraform module for managing AWS EC2 compute resources including single instances, Auto Scaling Groups, and advanced configurations.

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-%3E%3D5.0-FF9900?logo=amazon-aws)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**New to this module?** Check out the [Quick Start Guide](QUICKSTART.md) for step-by-step instructions on using this module in your own project!

## Features

This Terraform module provides three specialized submodules for different EC2 use cases:

### Basic Instance Module
- Simple EC2 instance provisioning
- Essential configurations (AMI, instance type, security groups)
- User data support
- Tag management
- Perfect for simple workloads and testing

### Auto Scaling Group Module
- Launch Template configuration
- Auto Scaling Group with configurable capacity
- Target tracking scaling policies (CPU, memory, request count)
- Health checks and monitoring
- Multi-AZ deployment support
- Integration with Application Load Balancers

### Advanced Instance Module
- Full-featured EC2 instance configuration
- Multiple EBS volume attachments
- IAM instance profile support
- Detailed monitoring options
- Network interface configuration
- Advanced user data and metadata options
- Spot instance support

## Module Structure

```
terraform-aws-compute-ec2/
├── modules/
│   ├── basic_instance/      # Simple EC2 instances
│   ├── asg/                 # Auto Scaling Groups
│   └── advanced_instance/   # Full-featured instances
├── examples/
│   ├── single-instance/     # Basic instance example
│   └── asg/                 # ASG example
├── test/
│   ├── terratest/           # Automated tests
│   └── smoke/               # Manual smoke tests
└── .github/workflows/       # CI/CD pipelines
```

## Using This Module in Your Project

### Prerequisites
- Terraform >= 1.0
- AWS credentials configured
- AWS Provider >= 5.0

### Installation

You can reference this module directly from GitHub in your Terraform configuration:

#### Option 1: Reference Specific Release (Recommended for Production)
```hcl
module "ec2" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/basic_instance?ref=v1.0.0"
  # ... configuration
}
```

#### Option 2: Reference Main Branch (Development)
```hcl
module "ec2" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/basic_instance"
  # ... configuration
}
```

#### Option 3: Reference Specific Commit
```hcl
module "ec2" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/basic_instance?ref=abc123def"
  # ... configuration
}
```

### Complete Project Setup

Create a new directory for your project and add the following files:

**main.tf:**
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

module "web_server" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/basic_instance"

  name               = "web-server"
  ami_id             = var.ami_id
  instance_type      = "t3.micro"
  subnet_id          = var.subnet_id
  security_group_ids = [var.security_group_id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
```

**variables.tf:**
```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "myapp"
}
```

**outputs.tf:**
```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.web_server.instance_id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.web_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.web_server.private_ip
}
```

**terraform.tfvars:**
```hcl
aws_region         = "us-east-1"
ami_id            = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
subnet_id         = "subnet-12345678"
security_group_id = "sg-12345678"
environment       = "dev"
project_name      = "myapp"
```

Then deploy:
```bash
terraform init
terraform plan
terraform apply
```

## Usage Examples

### Basic Instance

```hcl
module "web_server" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/basic_instance"

  name               = "web-server"
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.micro"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Auto Scaling Group

```hcl
module "app_asg" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/asg"

  name_prefix        = "app-asg"
  environment        = "prod"
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.micro"
  security_group_ids = ["sg-12345678"]

  min_size                = 2
  max_size                = 10
  desired_capacity        = 3
  vpc_zone_identifier     = ["subnet-12345678", "subnet-87654321"]

  enable_target_tracking_scaling = true
  target_tracking_metric_type    = "cpu"
  target_value                   = 70.0

  tags = {
    Environment = "prod"
    Project     = "myapp"
  }
}
```

### Advanced Instance

```hcl
module "app_server" {
  source = "github.com/kelleyblackmore/terraform-aws-compute-ec2//modules/advanced_instance"

  name               = "app-server"
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.medium"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]

  iam_instance_profile = "app-instance-profile"

  ebs_volumes = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 100
      iops        = 3000
      throughput  = 125
      encrypted   = true
      kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }
  ]

  enable_detailed_monitoring = true
  enable_termination_protection = true

  tags = {
    Environment = "prod"
    Application = "backend"
    Backup      = "daily"
  }
}
```

## Examples

Complete working examples are available in the [examples](./examples) directory:

- [single-instance](./examples/single-instance) - Basic EC2 instance with default VPC
- [asg](./examples/asg) - Auto Scaling Group with Apache web server

Each example includes:
- Complete Terraform configuration
- Variable definitions
- Outputs
- README with deployment instructions

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
- Appropriate AWS credentials and permissions

## Development

### Makefile Commands

This project includes a Makefile for common development tasks:

```bash
make help              # Show all available commands
make validate          # Validate all modules and examples
make format            # Format all Terraform files
make format-check      # Check if files are formatted
make lint              # Run tflint
make test              # Run all terratest tests
make docs              # Generate documentation
make clean             # Clean up terraform artifacts
make pre-commit        # Run all pre-commit checks
make ci                # Run CI pipeline checks
```

### Testing

#### Quick Validation
```bash
make validate          # Validate all modules and examples
```

#### Automated Testing

This module uses Terratest for automated integration testing:

```bash
make test              # Run all tests
make test-basic        # Run basic instance tests only
make test-asg          # Run ASG tests only
```

Or manually:
```bash
cd test/terratest
go mod tidy
go test -v -timeout 30m
```

#### Smoke Testing

Manual validation scripts are available in `test/smoke/`:

```bash
cd examples/single-instance
terraform apply
cd ../../test/smoke
# Follow instructions in README.md
```

### Working with Examples

```bash
make plan-basic        # Plan basic instance example
make apply-basic       # Apply basic instance example
make destroy-basic     # Destroy basic instance resources

make plan-asg          # Plan ASG example
make apply-asg         # Apply ASG example
make destroy-asg       # Destroy ASG resources
```

## CI/CD

GitHub Actions workflows automatically validate code quality:

- **validate.yml**: Runs on every PR and push
  - Terraform format check
  - Terraform validate
  - TFLint
  - terraform-docs verification

- **terratest.yml**: Runs on PR or manual trigger
  - Full integration tests with real AWS resources
  - Automatic cleanup on failure

## Module Documentation

Detailed documentation for each module:

- [basic_instance](./modules/basic_instance/README.md)
- [asg](./modules/asg/README.md)
- [advanced_instance](./modules/advanced_instance/README.md)

## Best Practices

1. **Use specific AMI IDs** rather than data sources in production
2. **Enable encryption** for EBS volumes containing sensitive data
3. **Use IMDSv2** for instance metadata (enabled by default in advanced module)
4. **Tag all resources** consistently for cost tracking and organization
5. **Use Launch Templates** instead of Launch Configurations (ASG module uses templates)
6. **Enable detailed monitoring** for production workloads
7. **Use IAM roles** instead of access keys for AWS API access

## Security Considerations

- Security groups should follow principle of least privilege
- Enable EBS encryption for sensitive workloads
- Use KMS keys for enhanced encryption control
- Implement IMDSv2 for instance metadata access
- Regular patching through user data or configuration management
- Use Systems Manager Session Manager instead of SSH when possible

## Cost Optimization

- Use appropriate instance types for workload requirements
- Consider spot instances for non-critical workloads (advanced module)
- Implement proper ASG scaling policies to match demand
- Use gp3 volumes instead of gp2 for better price/performance
- Enable termination protection for critical instances

## Troubleshooting

### Instance Launch Failures
- Check subnet availability zones
- Verify AMI availability in region
- Confirm security group and subnet are in same VPC
- Review IAM instance profile permissions

### ASG Not Scaling
- Check CloudWatch metrics are being published
- Verify scaling policies are properly configured
- Review health check settings
- Check capacity limits (min/max/desired)

### Connectivity Issues
- Verify security group rules allow required traffic
- Check network ACLs on subnets
- Confirm route tables for internet access
- Verify instance has public IP if needed

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and validation
5. Submit a pull request

Please ensure:
- Code is formatted with `terraform fmt`
- All modules pass `terraform validate`
- Tests pass locally
- Documentation is updated

## License

MIT License - see [LICENSE](./LICENSE) file for details.

## Authors

Maintained by Kelley Blackmore

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Submit a pull request
- Review existing documentation

## Changelog

See [releases](https://github.com/kelleyblackmore/terraform-aws-compute-ec2/releases) for version history and changes.