variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod-firewall"
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}


variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into EC2"
  type        = string
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