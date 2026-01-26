variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "sg_id" {
  description = "Security group ID"
  type        = string
}


variable "root_volume_type" {
  description = "Root volume type"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
}

variable "delete_on_termination" {
  description = "Delete root volume on termination"
  type        = bool
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}
