output "environment" {
  description = "Deployed environment"
  value       = var.environment
}

output "instance_count" {
  description = "Number of instances deployed"
  value       = var.instance_count
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.app[*].id
}

output "public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = aws_instance.app[*].public_ip
}

output "availability_zones" {
  description = "Availability Zones of the EC2 instances"
  value       = aws_instance.app[*].availability_zone
}
