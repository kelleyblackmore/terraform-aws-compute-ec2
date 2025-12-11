variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "ami_id" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When used in combination with user_data will trigger a destroy and recreate when set to true"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = true
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance"
  type        = bool
  default     = true
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance. Can be stop or terminate"
  type        = string
  default     = "stop"
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = null
}

variable "tenancy" {
  description = "The tenancy of the instance. Valid values are default, dedicated, host"
  type        = string
  default     = "default"
}

variable "host_id" {
  description = "The Id of a dedicated host that the instance will be assigned to"
  type        = string
  default     = null
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance"
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance"
  type        = number
  default     = null
}

variable "cpu_credits" {
  description = "The credit option for CPU usage. Valid values are standard or unlimited"
  type        = string
  default     = "standard"
}

variable "enclave_enabled" {
  description = "Whether Nitro Enclaves will be enabled on the instance"
  type        = bool
  default     = false
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

variable "root_volume_iops" {
  description = "Amount of provisioned IOPS for the root volume"
  type        = number
  default     = null
}

variable "root_volume_throughput" {
  description = "Throughput to provision for a volume in mebibytes per second (MiB/s)"
  type        = number
  default     = null
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
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}

variable "ephemeral_block_devices" {
  description = "Ephemeral block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "network_interfaces" {
  description = "Network interfaces to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "create_eip" {
  description = "Whether to create and associate an Elastic IP with the instance"
  type        = bool
  default     = false
}

variable "eip_allocation_id" {
  description = "Allocation ID of an existing EIP to associate with the instance"
  type        = string
  default     = null
}

variable "create_cpu_alarm" {
  description = "Whether to create a CloudWatch alarm for CPU utilization"
  type        = bool
  default     = false
}

variable "cpu_alarm_threshold" {
  description = "The value against which the CPUUtilization metric is compared"
  type        = number
  default     = 80
}

variable "cpu_alarm_evaluation_periods" {
  description = "The number of periods over which data is compared to the threshold"
  type        = number
  default     = 2
}

variable "cpu_alarm_period" {
  description = "The period in seconds over which the statistic is applied"
  type        = number
  default     = 300
}

variable "cpu_alarm_statistic" {
  description = "The statistic to apply to the alarm's associated metric"
  type        = string
  default     = "Average"
}

variable "cpu_alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state"
  type        = list(string)
  default     = []
}

variable "create_status_check_alarm" {
  description = "Whether to create a CloudWatch alarm for instance status checks"
  type        = bool
  default     = false
}

variable "status_check_alarm_evaluation_periods" {
  description = "The number of periods over which data is compared to the threshold"
  type        = number
  default     = 2
}

variable "status_check_alarm_period" {
  description = "The period in seconds over which the statistic is applied"
  type        = number
  default     = 60
}

variable "status_check_alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}
