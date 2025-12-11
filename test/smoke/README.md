# Smoke Tests

## Overview
This directory contains smoke test scripts and documentation for manual validation of the Terraform modules.

## Purpose
Smoke tests provide quick validation that the basic functionality of deployed resources is working as expected.

## Running Smoke Tests

### Prerequisites
- AWS CLI configured with appropriate credentials
- jq installed for JSON parsing
- Access to the AWS account where resources are deployed

### Basic Instance Smoke Test
```bash
# Get instance ID from Terraform output
INSTANCE_ID=$(terraform output -raw instance_id)

# Check instance state
aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].State.Name' --output text

# Expected output: running
```

### ASG Smoke Test
```bash
# Get ASG name from Terraform output
ASG_NAME=$(terraform output -raw asg_name)

# Check ASG health
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $ASG_NAME --query 'AutoScalingGroups[0].Instances[*].[InstanceId,HealthStatus]' --output table

# All instances should show "Healthy"
```

### Connectivity Test
```bash
# Test SSH connectivity (if instance has public IP and security group allows SSH)
PUBLIC_IP=$(terraform output -raw public_ip)
ssh -i /path/to/key.pem ec2-user@$PUBLIC_IP "echo 'Connection successful'"
```

## Test Checklist
- [ ] Instance is in running state
- [ ] Security group rules are applied correctly
- [ ] Tags are set as expected
- [ ] IAM role is attached (if configured)
- [ ] User data script executed successfully
- [ ] Instance is accessible via SSH/RDP (if configured)
- [ ] CloudWatch logs are being sent (if configured)

## Cleanup
Always destroy test resources after validation:
```bash
terraform destroy -auto-approve
```
