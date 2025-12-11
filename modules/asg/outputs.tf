output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.this.id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = aws_launch_template.this.arn
}

output "launch_template_latest_version" {
  description = "The latest version of the launch template"
  value       = aws_launch_template.this.latest_version
}

output "autoscaling_group_id" {
  description = "The Auto Scaling Group id"
  value       = aws_autoscaling_group.this.id
}

output "autoscaling_group_arn" {
  description = "The ARN for this Auto Scaling Group"
  value       = aws_autoscaling_group.this.arn
}

output "autoscaling_group_name" {
  description = "The Auto Scaling Group name"
  value       = aws_autoscaling_group.this.name
}

output "autoscaling_group_min_size" {
  description = "The minimum size of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.min_size
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.max_size
}

output "autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = aws_autoscaling_group.this.desired_capacity
}

output "autoscaling_group_availability_zones" {
  description = "The availability zones of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.availability_zones
}

output "autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = aws_autoscaling_group.this.vpc_zone_identifier
}

output "scale_up_policy_arn" {
  description = "The ARN of the scale up policy"
  value       = var.enable_scaling_policies ? aws_autoscaling_policy.scale_up[0].arn : null
}

output "scale_down_policy_arn" {
  description = "The ARN of the scale down policy"
  value       = var.enable_scaling_policies ? aws_autoscaling_policy.scale_down[0].arn : null
}

output "cpu_high_alarm_arn" {
  description = "The ARN of the CPU high CloudWatch alarm"
  value       = var.enable_scaling_policies ? aws_cloudwatch_metric_alarm.cpu_high[0].arn : null
}

output "cpu_low_alarm_arn" {
  description = "The ARN of the CPU low CloudWatch alarm"
  value       = var.enable_scaling_policies ? aws_cloudwatch_metric_alarm.cpu_low[0].arn : null
}
