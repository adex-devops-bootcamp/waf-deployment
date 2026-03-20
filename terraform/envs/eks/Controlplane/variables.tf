variable "cluster_name" {
  description = "cluster name"
  type = string
}

variable "eks_version" {
  description = "eks version"
  type = string
  default = "1.31"
}

variable "tags" {
  description = "tags"
  type = map(string)
}

variable "subnet_ids" {
  description = "List of subnet ids"
  type = list(string)
}

variable "authentication_mode" {
  description = "authentication mode for eks"
  type = string
  default = "API"
}