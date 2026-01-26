module "sg" {
  source = "../../modules/sg"

  environment = var.environment
  vpc_id      = var.vpc_id
  tags        = var.tags
}

module "ec2" {
  source = "../../modules/ec2"

  instance_type         = var.instance_type
  subnet_id             = var.subnet_id
  sg_id                 = module.sg.security_group_id
  root_volume_type      = var.root_volume_type
  root_volume_size      = var.root_volume_size
  delete_on_termination = var.delete_on_termination
  tags                  = var.tags
  environment           = var.environment

  iam_instance_profile_name = aws_iam_instance_profile.firewall.name
}
