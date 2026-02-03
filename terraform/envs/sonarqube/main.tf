module "vpc" {
  source = "../../modules/vpc"

  # VPC
  vpc_name       = var.environment
  vpc_cidr_block = var.vpc_cidr

  # AZ
  number_of_az = var.number_of_az
  vpc_azs      = var.vpc_azs


  # Public subnets
  number_of_public_subnets  = var.number_of_public_subnets
  public_subnets_cidr_block = var.public_subnets_cidr_block


  # Private subnets
  number_of_private_subnets  = var.number_of_private_subnets
  private_subnets_cidr_block = var.private_subnets_cidr_block
}


module "sg" {
  source      = "./modules/sg"
  name        = "${var.environment}-sg"
  description = "Allow http and https"
  vpc_id      = module.vpc.vpc_id
  tags = var.tags

  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "ec2" {
  source = "../../modules/ec2"

  instance_type        = var.instance_type
  subnet_id            = module.vpc.public_subnet_ids[0]
  sg_id                = module.sg.security_group_id
  root_volume_type     = var.root_volume_type
  root_volume_size     = var.root_volume_size
  delete_on_termination = var.delete_on_termination
  tags                 = var.tags
  environment          = var.environment

  iam_instance_profile_name = aws_iam_instance_profile.firewall.name
}
