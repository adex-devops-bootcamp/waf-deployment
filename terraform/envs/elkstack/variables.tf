variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default = "eu-north-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod-firewall"
}


variable "instance_type" {
  type = string
}

variable "root_volume_type" {
  type = string
}

variable "root_volume_size" {
  type = number
}

variable "delete_on_termination" {
  type = bool
}

variable "tags" {
  type = map(string)
}
variable "subnet_az" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "zone_id" {
  description = "Hosted Zone ID"
  type = string
}