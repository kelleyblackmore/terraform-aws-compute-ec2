# Basic Instance Module

This module creates a single EC2 instance with configurable options.

## Features

- Launch a single EC2 instance
- Configure root volume settings (size, type, encryption)
- Attach additional EBS volumes
- Configure security groups and networking
- IAM instance profile support
- User data configuration
- Detailed monitoring option
- Tagging support

## Usage

```hcl
module "ec2_instance" {
  source = "../../modules/basic_instance"

  name                        = "my-instance"
  ami_id                      = "ami-0abcdef1234567890"
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-12345678"
  security_group_ids          = ["sg-12345678"]
  key_name                    = "my-key"
  associate_public_ip_address = true

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
| name | Name to be used on EC2 instance created | `string` | n/a | yes |
| ami_id | ID of AMI to use for the instance | `string` | n/a | yes |
| instance_type | The type of instance to start | `string` | `"t3.micro"` | no |
| subnet_id | The VPC Subnet ID to launch in | `string` | n/a | yes |
| security_group_ids | A list of security group IDs to associate with | `list(string)` | `[]` | no |
| key_name | Key name of the Key Pair to use for the instance | `string` | `null` | no |
| associate_public_ip_address | Whether to associate a public IP address with an instance in a VPC | `bool` | `false` | no |
| user_data | The user data to provide when launching the instance | `string` | `null` | no |
| iam_instance_profile | IAM Instance Profile to launch the instance with | `string` | `null` | no |
| enable_monitoring | If true, the launched EC2 instance will have detailed monitoring enabled | `bool` | `false` | no |
| root_volume_type | Type of root volume | `string` | `"gp3"` | no |
| root_volume_size | Size of the root volume in gigabytes | `number` | `20` | no |
| root_volume_encrypted | Whether to enable root volume encryption | `bool` | `true` | no |
| ebs_block_devices | Additional EBS block devices to attach to the instance | `list(any)` | `[]` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the instance |
| arn | The ARN of the instance |
| public_ip | The public IP address assigned to the instance |
| private_ip | The private IP address assigned to the instance |
| availability_zone | The availability zone of the instance |
