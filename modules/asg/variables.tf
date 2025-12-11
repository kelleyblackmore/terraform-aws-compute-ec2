variable "name" {
  description = "Name to be used for the Auto Scaling Group and related resources"
  type        = string
}

variable "ami_id" {
  description = "ID of AMI to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instances"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "user_data" {
  description = "The user data to provide when launching the instances"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instances with"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "If true, the launched EC2 instances will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = number
  default     = 1
}

variable "target_group_arns" {
  description = "A set of aws_alb_target_group ARNs for use with Application or Network Load Balancing"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the Auto Scaling Group should be terminated"
  type        = list(string)
  default     = ["Default"]
}

variable "enabled_metrics" {
  description = "A list of metrics to collect for the Auto Scaling Group"
  type        = list(string)
  default     = []
}

variable "launch_template_description" {
  description = "Description of the launch template"
  type        = string
  default     = "Launch template for Auto Scaling Group"
}

variable "launch_template_version" {
  description = "Launch template version. Can be version number, $Latest, or $Default"
  type        = string
  default     = "$Latest"
}

variable "root_volume_type" {
  description = "Type of root volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  type        = number
  default     = 20
}

variable "root_volume_delete_on_termination" {
  description = "Whether the root volume should be destroyed on instance termination"
  type        = bool
  default     = true
}

variable "root_volume_encrypted" {
  description = "Whether to enable root volume encryption"
  type        = bool
  default     = true
}

variable "root_volume_kms_key_id" {
  description = "The ARN of the AWS Key Management Service key to use for root volume encryption"
  type        = string
  default     = null
}

variable "ebs_block_devices" {
  description = "Additional EBS block devices to attach to the instances"
  type        = list(any)
  default     = []
}

variable "metadata_http_endpoint" {
  description = "Whether the metadata service is available"
  type        = string
  default     = "enabled"
}

variable "metadata_http_tokens" {
  description = "Whether or not the metadata service requires session tokens (IMDSv2)"
  type        = string
  default     = "required"
}

variable "metadata_http_put_response_hop_limit" {
  description = "The desired HTTP PUT response hop limit for instance metadata requests"
  type        = number
  default     = 1
}

variable "metadata_instance_tags" {
  description = "Enables or disables access to instance tags from the instance metadata service"
  type        = string
  default     = "disabled"
}

variable "instance_refresh_enabled" {
  description = "Whether to enable instance refresh"
  type        = bool
  default     = false
}

variable "instance_refresh_strategy" {
  description = "The strategy to use for instance refresh"
  type        = string
  default     = "Rolling"
}

variable "instance_refresh_min_healthy_percentage" {
  description = "The minimum healthy percentage during instance refresh"
  type        = number
  default     = 90
}

variable "instance_refresh_instance_warmup" {
  description = "The number of seconds until a newly launched instance is configured and ready to use"
  type        = number
  default     = null
}

variable "enable_scaling_policies" {
  description = "Whether to create scaling policies and CloudWatch alarms"
  type        = bool
  default     = false
}

variable "scale_up_adjustment" {
  description = "The number of instances to add when scaling up"
  type        = number
  default     = 1
}

variable "scale_up_cooldown" {
  description = "The amount of time, in seconds, after a scale up activity completes before another can start"
  type        = number
  default     = 300
}

variable "scale_down_adjustment" {
  description = "The number of instances to remove when scaling down"
  type        = number
  default     = -1
}

variable "scale_down_cooldown" {
  description = "The amount of time, in seconds, after a scale down activity completes before another can start"
  type        = number
  default     = 300
}

variable "cpu_high_threshold" {
  description = "The value against which the CPUUtilization metric is compared for scale up"
  type        = number
  default     = 80
}

variable "cpu_high_evaluation_periods" {
  description = "The number of periods over which data is compared to the high threshold"
  type        = number
  default     = 2
}

variable "cpu_high_period" {
  description = "The period in seconds over which the high statistic is applied"
  type        = number
  default     = 300
}

variable "cpu_low_threshold" {
  description = "The value against which the CPUUtilization metric is compared for scale down"
  type        = number
  default     = 20
}

variable "cpu_low_evaluation_periods" {
  description = "The number of periods over which data is compared to the low threshold"
  type        = number
  default     = 2
}

variable "cpu_low_period" {
  description = "The period in seconds over which the low statistic is applied"
  type        = number
  default     = 300
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the volumes created by instances at launch time"
  type        = map(string)
  default     = {}
}
