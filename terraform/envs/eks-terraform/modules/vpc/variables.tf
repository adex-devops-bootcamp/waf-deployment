variable "vpc_name" {}
variable "vpc_cidr" {}
variable "public_azs" {
  type = list(string)
}
variable "public_subnets_cidrs" {
  type = list(string)
}