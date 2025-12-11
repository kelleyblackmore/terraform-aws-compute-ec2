output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.id
}

output "instance_public_ip" {
  description = "The public IP address of the instance"
  value       = module.ec2_instance.public_ip
}

output "instance_public_dns" {
  description = "The public DNS name of the instance"
  value       = module.ec2_instance.public_dns
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.example.id
}

output "nginx_url" {
  description = "URL to access the nginx welcome page"
  value       = "http://${module.ec2_instance.public_ip}"
}
