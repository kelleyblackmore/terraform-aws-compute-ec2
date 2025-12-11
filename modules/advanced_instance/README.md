# Advanced Instance Module

This module creates a single EC2 instance with advanced configuration options including placement groups, CPU options, Elastic IPs, CloudWatch alarms, and more.

## Features

- Launch a single EC2 instance with advanced options
- Configure root volume and additional EBS volumes
- Elastic IP management (create new or associate existing)
- Network interface configuration
- Placement group support
- CPU core and thread configuration
- Nitro Enclaves support
- Instance termination and stop protection
- CloudWatch alarms for CPU and status checks
- IMDSv2 support
- Detailed monitoring option
- Ephemeral block devices
- Comprehensive tagging support

## Usage

```hcl
module "advanced_ec2" {
  source = "../../modules/advanced_instance"

  name                        = "my-advanced-instance"
  ami_id                      = "ami-0abcdef1234567890"
  instance_type               = "t3.large"
  subnet_id                   = "subnet-12345678"
  security_group_ids          = ["sg-12345678"]
  key_name                    = "my-key"
  associate_public_ip_address = true

  ebs_optimized               = true
  enable_monitoring           = true
  disable_api_termination     = true

  # CPU configuration
  cpu_core_count        = 2
  cpu_threads_per_core  = 1

  # Storage configuration
  root_volume_size      = 50
  root_volume_type      = "gp3"
  root_volume_iops      = 3000
  root_volume_throughput = 125
  root_volume_encrypted = true

  ebs_block_devices = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 100
      encrypted   = true
      iops        = 3000
      throughput  = 125
    }
  ]

  # Elastic IP
  create_eip = true

  # CloudWatch alarms
  create_cpu_alarm = true
  cpu_alarm_threshold = 85
  cpu_alarm_actions = ["arn:aws:sns:us-east-1:123456789012:my-topic"]

  create_status_check_alarm = true
  status_check_alarm_actions = ["arn:aws:sns:us-east-1:123456789012:my-topic"]

  # Metadata configuration (IMDSv2)
  metadata_http_tokens = "required"
  metadata_instance_tags = "enabled"

  tags = {
    Environment = "production"
    Project     = "critical-app"
    Backup      = "daily"
  }

  volume_tags = {
    VolumeBackup = "enabled"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name to be used on EC2 instance created | `string` | n/a | yes |
| ami_id | ID of AMI to use for the instance | `string` | n/a | yes |
| instance_type | The type of instance to start | `string` | `"t3.micro"` | no |
| subnet_id | The VPC Subnet ID to launch in | `string` | n/a | yes |
| ebs_optimized | If true, the launched EC2 instance will be EBS-optimized | `bool` | `true` | no |
| disable_api_termination | If true, enables EC2 Instance Termination Protection | `bool` | `false` | no |
| placement_group | The Placement Group to start the instance in | `string` | `null` | no |
| cpu_core_count | Sets the number of CPU cores for an instance | `number` | `null` | no |
| cpu_threads_per_core | Sets the number of CPU threads per core | `number` | `null` | no |
| create_eip | Whether to create and associate an Elastic IP | `bool` | `false` | no |
| create_cpu_alarm | Whether to create a CloudWatch alarm for CPU | `bool` | `false` | no |
| cpu_alarm_threshold | CPU utilization threshold for alarm | `number` | `80` | no |
| metadata_http_tokens | Whether metadata service requires session tokens | `string` | `"required"` | no |

See `variables.tf` for complete list of inputs.

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the instance |
| arn | The ARN of the instance |
| public_ip | The public IP address assigned to the instance |
| private_ip | The private IP address assigned to the instance |
| eip_public_ip | The Elastic IP address (if created) |
| cpu_alarm_arn | The ARN of the CPU CloudWatch alarm |
| status_check_alarm_arn | The ARN of the status check alarm |

## Advanced Features

### Elastic IP Management
- Create and associate a new EIP: `create_eip = true`
- Associate an existing EIP: `eip_allocation_id = "eipalloc-xxxx"`

### CloudWatch Monitoring
- CPU utilization alarms with customizable thresholds
- Instance status check alarms
- Support for SNS notifications

### CPU Optimization
- Configure CPU cores and threads per core
- Useful for licensing optimization
- Control hyperthreading

### Security Features
- IMDSv2 enforcement
- Instance termination protection
- Instance stop protection
- Nitro Enclaves support
