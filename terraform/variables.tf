variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod-firewall"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "number_of_az" {
  description = "Number of availability zone for vpc"
  type        = number
  default     = 1
}

variable "vpc_azs" {
  description = "Availability zone"
  type        = list(string)
  default     = ["us-east-1"]
}

variable "number_of_public_subnets" {
  description = "Number of public subnets to create"
  type        = number
  default     = 1
}

variable "public_subnets_cidr_block" {
  description = "Public subnets cidr blocks"
  type        = list(string)
  default     = ["10.0.0.0/28"]
}

variable "number_of_private_subnets" {
  description = "Number of private subnets to create"
  type        = number
  default     = 0
}

variable "private_subnets_cidr_block" {
  description = "Private subnets cidr blocks"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default = {
    Project     = "firewall"
    Environment = "prod-firewall"
    ManagedBy   = "terraform"
  }
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into EC2"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}