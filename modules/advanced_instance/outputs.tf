output "id" {
  description = "The ID of the instance"
  value       = aws_instance.this.id
}

output "arn" {
  description = "The ARN of the instance"
  value       = aws_instance.this.arn
}

output "instance_state" {
  description = "The state of the instance"
  value       = aws_instance.this.instance_state
}

output "public_dns" {
  description = "The public DNS name assigned to the instance"
  value       = aws_instance.this.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance"
  value       = aws_instance.this.public_ip
}

output "private_dns" {
  description = "The private DNS name assigned to the instance"
  value       = aws_instance.this.private_dns
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = aws_instance.this.private_ip
}

output "availability_zone" {
  description = "The availability zone of the instance"
  value       = aws_instance.this.availability_zone
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = aws_instance.this.primary_network_interface_id
}

output "outpost_arn" {
  description = "The ARN of the Outpost the instance is assigned to"
  value       = aws_instance.this.outpost_arn
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance"
  value       = aws_instance.this.password_data
  sensitive   = true
}

output "placement_group" {
  description = "The placement group of the instance"
  value       = aws_instance.this.placement_group
}

output "eip_id" {
  description = "The ID of the Elastic IP"
  value       = var.create_eip ? aws_eip.this[0].id : null
}

output "eip_public_ip" {
  description = "The Elastic IP address"
  value       = var.create_eip ? aws_eip.this[0].public_ip : null
}

output "eip_allocation_id" {
  description = "The allocation ID of the Elastic IP"
  value       = var.create_eip ? aws_eip.this[0].allocation_id : null
}

output "cpu_alarm_arn" {
  description = "The ARN of the CPU CloudWatch alarm"
  value       = var.create_cpu_alarm ? aws_cloudwatch_metric_alarm.cpu[0].arn : null
}

output "status_check_alarm_arn" {
  description = "The ARN of the status check CloudWatch alarm"
  value       = var.create_status_check_alarm ? aws_cloudwatch_metric_alarm.status_check[0].arn : null
}

output "tags_all" {
  description = "A map of tags assigned to the resource"
  value       = aws_instance.this.tags_all
}
