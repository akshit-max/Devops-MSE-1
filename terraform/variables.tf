variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "multi-env-ecommerce"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
}

variable "app_port" {
  description = "Port the Flask application runs on"
  type        = number
  default     = 5000
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = "DevOps-Team"
}

variable "my_ip" {
  description = "Your public IP address in CIDR notation for SSH access (e.g. x.x.x.x/32). Use 0.0.0.0/0 if unknown."
  type        = string
  default     = "0.0.0.0/0"
}
