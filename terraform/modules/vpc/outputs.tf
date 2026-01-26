output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = module.public_subnets.subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = module.private_subnets.subnet_ids
}
