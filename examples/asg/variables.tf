variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
  default     = "demo"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name for EC2 instances"
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from ASG Instance $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
}

variable "allowed_http_cidr_blocks" {
  description = "List of CIDR blocks allowed to access HTTP. Use ['0.0.0.0/0'] for public access or specific IPs for restricted access"
  type        = list(string)
  default     = [] # Empty by default - must be explicitly set
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH. Recommended to use specific IP addresses. Get your IP: curl -s https://checkip.amazonaws.com"
  type        = list(string)
  default     = [] # Empty by default for security
}

variable "enable_ssh_access" {
  description = "Enable SSH access to ASG instances"
  type        = bool
  default     = false
}
