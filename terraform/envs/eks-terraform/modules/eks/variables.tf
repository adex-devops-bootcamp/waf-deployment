variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster to be created."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs where the EKS control plane and node group will be deployed."
}

variable "node_instance_types" {
  type        = list(string)
  description = "List of EC2 instance types for the EKS managed node group."
  default     = ["t3.micro"]
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of worker nodes in the EKS node group."
  default     = 1
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of worker nodes in the EKS node group."
  default     = 1
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of worker nodes in the EKS node group."
  default     = 1
}

variable "node_capacity_type" {
  type        = string
  description = "Capacity type for EKS node group. Valid values: ON_DEMAND or SPOT."
  default     = "ON_DEMAND"
}
