# Auto Scaling Group Example

This example demonstrates how to use the ASG module to create an Auto Scaling Group with a Launch Template.

## Security Notice

**This example creates NO ingress rules by default for security.** You must explicitly configure access:

- SSH access is **disabled by default**
- HTTP access requires explicit CIDR blocks
- No ports are open to the internet by default

For production ASG behind a load balancer, you typically:
- Allow HTTP from the load balancer security group (not 0.0.0.0/0)
- Enable SSH from a bastion host only (not public internet)
- Use AWS Systems Manager Session Manager instead of SSH

## Features
- Auto Scaling Group with configurable min/max/desired capacity
- Launch Template with Amazon Linux 2 AMI
- Configurable security group with restrictive defaults
- User data script to install and configure Apache web server
- Integration with default VPC and subnets
- Health check configuration

## Security Configuration

### Get Your Public IP
```bash
MY_IP=$(curl -s https://checkip.amazonaws.com)
echo "Your IP: $MY_IP/32"
```

### Configure Access

Create a `terraform.tfvars` file:

```hcl
# For public web server
allowed_http_cidr_blocks = ["0.0.0.0/0"]

# For restricted access (development)
# allowed_http_cidr_blocks = ["YOUR_IP/32"]

# Enable SSH (not recommended for production)
enable_ssh_access       = true
allowed_ssh_cidr_blocks = ["YOUR_IP/32"]

# Optional: specify key pair
key_name = "your-key-pair"
```

### Production Recommendations

For production, use a load balancer and restrict access:

```hcl
# Allow HTTP only from load balancer security group
# (Modify example to accept security group IDs instead of CIDR blocks)

# No SSH - use Systems Manager Session Manager
enable_ssh_access = false

# Or SSH only from bastion host
enable_ssh_access       = true
allowed_ssh_cidr_blocks = ["10.0.1.0/24"]  # Bastion subnet
```

## Prerequisites
- AWS credentials configured
- Default VPC available (or modify to use custom VPC)
- Your public IP address
- (Optional) EC2 key pair for instance access

## Usage Example

```hcl
module "asg" {
  source = "../../modules/asg"

  name          = "my-app-prod"
  ami_id        = "ami-xxxxx"
  instance_type = "t3.micro"
  
  # Security - provide specific security groups
  security_group_ids = ["sg-xxxxx"]
  
  min_size         = 2
  max_size         = 10
  desired_capacity = 3
  
  subnet_ids = ["subnet-xxxxx", "subnet-yyyyy"]
  
  tags = {
    Environment = "prod"
    Project     = "my-app"
  }
}
```

## Deployment

```bash
# Create terraform.tfvars with security settings
cat > terraform.tfvars <<EOF
allowed_http_cidr_blocks = ["0.0.0.0/0"]  # For public access
# Or use your IP: ["$(curl -s https://checkip.amazonaws.com)/32"]
EOF

# Initialize and apply
terraform init
terraform plan
terraform apply
```

## Testing

After deployment, the ASG will launch instances with Apache web server installed. You can:
1. Get instance IPs from AWS console
2. Access http://INSTANCE_IP to see the welcome page
3. Monitor ASG scaling behavior in CloudWatch

## Cleanup

```bash
terraform destroy
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aws_region | AWS region | string | us-east-1 |
| project | Project name | string | demo |
| environment | Environment name | string | dev |
| instance_type | EC2 instance type | string | t3.micro |
| min_size | Minimum ASG size | number | 1 |
| max_size | Maximum ASG size | number | 3 |
| desired_capacity | Desired ASG capacity | number | 2 |

## Outputs

| Name | Description |
|------|-------------|
| asg_name | Auto Scaling Group name |
| asg_arn | Auto Scaling Group ARN |
| launch_template_id | Launch Template ID |
| security_group_id | Security Group ID |
