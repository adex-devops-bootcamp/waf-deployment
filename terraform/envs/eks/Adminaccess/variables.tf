variable "cluster_name" {
  description = "cluster name"
  type = string
}

variable "tags" {
  description = "tags"
  type = map(string)
}

variable "admin_list" {
  description = "list of admin arn"
  type = list(string)
}