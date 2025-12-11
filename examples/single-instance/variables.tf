variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH. Use your IP address for security. Get it with: curl -s https://checkip.amazonaws.com"
  type        = list(string)
  default     = [] # Empty by default for security - must be explicitly set
}

variable "allowed_http_cidr_blocks" {
  description = "List of CIDR blocks allowed to access HTTP. Use ['0.0.0.0/0'] only for public web servers"
  type        = list(string)
  default     = [] # Empty by default for security - must be explicitly set
}

variable "enable_ssh_access" {
  description = "Enable SSH access to the instance. Requires allowed_ssh_cidr_blocks to be set"
  type        = bool
  default     = false
}

variable "enable_http_access" {
  description = "Enable HTTP access to the instance. Requires allowed_http_cidr_blocks to be set"
  type        = bool
  default     = false
}
