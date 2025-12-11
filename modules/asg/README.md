# Auto Scaling Group Module

This module creates an AWS Auto Scaling Group with a Launch Template and optional scaling policies.

## Features

- Launch Template with configurable settings
- Auto Scaling Group with configurable capacity
- Optional CPU-based scaling policies
- CloudWatch alarms for scaling triggers
- Instance refresh support
- Load balancer integration support
- EBS volume configuration
- IMDSv2 support
- Detailed monitoring option
- Tagging support

## Usage

```hcl
module "asg" {
  source = "../../modules/asg"

  name               = "my-asg"
  ami_id             = "ami-0abcdef1234567890"
  instance_type      = "t3.micro"
  subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  security_group_ids = ["sg-12345678"]
  key_name           = "my-key"

  min_size         = 1
  max_size         = 5
  desired_capacity = 2

  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = ["arn:aws:elasticloadbalancing:..."]

  enable_scaling_policies = true
  cpu_high_threshold      = 80
  cpu_low_threshold       = 20

  root_volume_size      = 30
  root_volume_type      = "gp3"
  root_volume_encrypted = true

  tags = {
    Environment = "dev"
    Project     = "example"
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
| name | Name for the Auto Scaling Group and related resources | `string` | n/a | yes |
| ami_id | ID of AMI to use for the instances | `string` | n/a | yes |
| instance_type | The type of instance to start | `string` | `"t3.micro"` | no |
| subnet_ids | A list of subnet IDs to launch resources in | `list(string)` | n/a | yes |
| security_group_ids | A list of security group IDs to associate with | `list(string)` | `[]` | no |
| min_size | The minimum size of the Auto Scaling Group | `number` | `1` | no |
| max_size | The maximum size of the Auto Scaling Group | `number` | `3` | no |
| desired_capacity | The number of instances that should be running | `number` | `1` | no |
| health_check_type | EC2 or ELB health check type | `string` | `"EC2"` | no |
| target_group_arns | List of target group ARNs for load balancing | `list(string)` | `[]` | no |
| enable_scaling_policies | Whether to create scaling policies | `bool` | `false` | no |
| cpu_high_threshold | CPU threshold for scale up | `number` | `80` | no |
| cpu_low_threshold | CPU threshold for scale down | `number` | `20` | no |
| root_volume_size | Size of the root volume in gigabytes | `number` | `20` | no |
| root_volume_type | Type of root volume | `string` | `"gp3"` | no |
| tags | A mapping of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| launch_template_id | The ID of the launch template |
| autoscaling_group_id | The Auto Scaling Group id |
| autoscaling_group_arn | The ARN for this Auto Scaling Group |
| autoscaling_group_name | The Auto Scaling Group name |
| scale_up_policy_arn | The ARN of the scale up policy |
| scale_down_policy_arn | The ARN of the scale down policy |

## Scaling Policies

When `enable_scaling_policies` is set to `true`, the module creates:
- Scale up policy triggered when CPU > cpu_high_threshold
- Scale down policy triggered when CPU < cpu_low_threshold
- CloudWatch alarms for monitoring
