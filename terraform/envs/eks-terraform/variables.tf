# AWS region
variable "aws_region" {
  default = "us-east-1"
}

# VPC inputs
variable "vpc_name" {
  description = "Name of the VPC"
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
}
variable "public_azs" {
  description = "AZs for public subnets"
  type        = list(string)
}
variable "public_subnets_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

# EKS cluster name
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "access_key" {
  description = "AWS access key for Terraform user"
  type        = string
}
variable "secret_key" {
  description = "AWS secret key for Terraform user"
  type        = string
}

# -------------------------------
# Node Group variables for EKS
# -------------------------------

variable "node_instance_types" {
  description = "Instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "node_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 1
}

variable "node_capacity_type" {
  description = "Capacity type for node group: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

