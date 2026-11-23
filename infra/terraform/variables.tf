variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "project" {
  description = "Name prefix for all resources"
  type        = string
  default     = "auto-monitor"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Two public subnets (load balancer, NAT gateway)"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Two private subnets (application, database)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "app_instance_type" {
  description = "EC2 instance type of the application host"
  type        = string
  default     = "t3.medium"
}

variable "db_instance_class" {
  description = "RDS instance class of the MySQL database"
  type        = string
  default     = "db.t3.medium"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate used by the HTTPS listeners"
  type        = string
}

variable "availability_zones" {
  description = "The two availability zones used by the subnets (pinned, so the result never drifts)"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}
