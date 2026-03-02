variable "cluster_name" { type = string }
variable "cluster_version" { type = string }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "cluster_role_arn" { type = string }
variable "node_role_arn" { type = string }

variable "node_groups" {
  type = map(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
  }))
}

variable "eks_admin_users" { type = list(string) }
