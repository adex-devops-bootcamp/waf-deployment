#########################################
# VPC / Networking
#########################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AZs for subnets"
  type        = list(string)
}
#########################################
# EC2 / SonarQube
#########################################

variable "ec2_instance_type" {
  description = "EC2 instance type for SonarQube"
  type        = string
  default     = "t2.large"
}

variable "ec2_key_name" {
  description = "SSH key pair name for EC2 instance"
  type        = string
  default = "Riwaj-Key"
}

#########################################
# AWS / Environment
#########################################

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "SonarQube"
    ManagedBy   = "Terraform"
  }
}
