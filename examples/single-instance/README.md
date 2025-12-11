# Single EC2 Instance Example

This example demonstrates how to use the `basic_instance` module to launch a single EC2 instance with a web server.

## Security Notice

**This example creates NO ingress rules by default for security.** You must explicitly enable and configure access:

- SSH access is **disabled by default**
- HTTP access is **disabled by default**
- You must provide specific CIDR blocks for any access you want to enable

## Features

- Launches a single EC2 instance
- Installs and configures a basic web server
- Configurable security group with restrictive defaults
- Uses default VPC and subnet
- Encrypted root volume
- User data script for initial configuration

## Prerequisites

- AWS account and credentials configured
- Terraform >= 1.0
- AWS Provider >= 5.0
- (Optional) EC2 key pair for SSH access
- Your public IP address (get it with: `curl -s https://checkip.amazonaws.com`)

## Security Configuration

### Get Your Public IP
```bash
MY_IP=$(curl -s https://checkip.amazonaws.com)
echo "Your IP: $MY_IP/32"
```

### Configure Access

Create a `terraform.tfvars` file:

```hcl
# For SSH access from your IP only
enable_ssh_access        = true
allowed_ssh_cidr_blocks  = ["YOUR_IP/32"]  # Replace with your actual IP

# For HTTP access (public web server)
enable_http_access       = true
allowed_http_cidr_blocks = ["0.0.0.0/0"]   # Public access

# Or restrict HTTP to specific IPs
# allowed_http_cidr_blocks = ["YOUR_IP/32", "OFFICE_IP/32"]

# Optional: specify key pair for SSH
key_name = "your-key-pair-name"
```

### Example Configurations

#### Public Web Server (HTTP only, no SSH)
```hcl
enable_http_access       = true
allowed_http_cidr_blocks = ["0.0.0.0/0"]
```

#### Development Instance (SSH + HTTP from your IP)
```hcl
enable_ssh_access        = true
allowed_ssh_cidr_blocks  = ["1.2.3.4/32"]
enable_http_access       = true
allowed_http_cidr_blocks = ["1.2.3.4/32"]
key_name                 = "my-key"
```

#### Internal Server (no public access)
```hcl
# Leave defaults - no ingress rules will be created
# Access via VPN, bastion host, or Systems Manager Session Manager
```

## Usage

```bash
# Get your IP
curl -s https://checkip.amazonaws.com

# Create terraform.tfvars with your settings
cat > terraform.tfvars <<EOF
enable_http_access       = true
allowed_http_cidr_blocks = ["0.0.0.0/0"]
enable_ssh_access        = true
allowed_ssh_cidr_blocks  = ["$(curl -s https://checkip.amazonaws.com)/32"]
EOF

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Access the web server (if HTTP enabled)
curl http://$(terraform output -raw public_ip)
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region to deploy resources | `string` | `"us-east-1"` | no |
| instance_type | EC2 instance type | `string` | `"t3.micro"` | no |
| key_name | Name of the EC2 key pair | `string` | `null` | no |
| enable_monitoring | Enable detailed monitoring | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | The ID of the EC2 instance |
| instance_public_ip | The public IP address of the instance |
| instance_public_dns | The public DNS name of the instance |
| nginx_url | URL to access the nginx welcome page |

## Testing

After deployment:

1. Wait a few minutes for the instance to initialize and user data to execute
2. Access the nginx URL from the outputs: `http://<public-ip>`
3. You should see a custom welcome page

## SSH Access

If you provided a key pair name:

```bash
ssh -i /path/to/your-key.pem ubuntu@<public-ip>
```

## Cleanup

```bash
terraform destroy
```

## Cost Considerations

- t3.micro instance: ~$0.0104/hour in us-east-1
- EBS storage: ~$0.08/GB-month for gp3 volumes
- Data transfer charges may apply

## Security Considerations

This example opens SSH (22) and HTTP (80) to the entire internet (0.0.0.0/0). For production use:
- Restrict SSH access to specific IP ranges
- Consider using AWS Systems Manager Session Manager instead of SSH
- Place instances in private subnets with a load balancer
- Enable additional security features like IMDSv2
