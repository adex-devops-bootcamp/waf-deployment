variable "vpc_name" {}
variable "vpc_cidr" {}
variable "public_azs" {
  type = list(string)
}
variable "public_subnets_cidrs" {
  type = list(string)
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Private subnet CIDR blocks"
}

variable "private_azs" {
  type        = list(string)
  description = "Availability zones for private subnets"
}