variable "aws_region" {}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16" # or any CIDR you want
}
variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}
variable "cluster_version" {
  type        = string
  description = "Kubernetes version of the EKS cluster"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs for the EKS cluster"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs for the EKS cluster"
}


variable "node_groups" {
  type = map(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
  }))
}

variable "eks_admin_users" {
  description = "IAM ARNs that should have Kubernetes cluster-admin"
  type        = list(string)
}
