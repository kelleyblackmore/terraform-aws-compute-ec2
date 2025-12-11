output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.asg.autoscaling_group_name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = module.asg.autoscaling_group_arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = module.asg.launch_template_id
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = module.asg.launch_template_latest_version
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.asg.id
}
