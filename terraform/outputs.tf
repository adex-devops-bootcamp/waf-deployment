############################
# VPC Outputs
############################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

############################
# EC2 Outputs
############################

output "ec2_instance_id" {
  description = "The ID of the EC2 instance deployed"
  value       = module.ec2.instance_id
}

# This is not required as we already have Elastic IP
# output "ec2_public_ip" {
#   description = "The public IP address of the EC2 instance"
#   value       = module.ec2.public_ip
# }

output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2.private_ip
}

output "ec2_eip" {
  description = "The Elastic IP address associated with the EC2 instance (if assigned)"
  value       = module.ec2.ec2_eip
}