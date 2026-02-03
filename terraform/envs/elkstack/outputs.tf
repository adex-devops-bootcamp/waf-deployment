############################
# VPC Outputs
############################

output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "public_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
}


output "private_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

############################
# EC2 Outputs
############################

output "ec2_instance_id" {
  description = "The ID of the EC2 instance deployed"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2.private_ip
}

output "ec2_eip" {
  description = "The Elastic IP address associated with the EC2 instance (if assigned)"
  value       = module.ec2.ec2_eip
}
