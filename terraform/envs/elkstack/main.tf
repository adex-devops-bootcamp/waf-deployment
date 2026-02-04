module "sg" {
  source      = "../../modules/sg"
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
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  sg_id                = module.sg.security_group_id
  root_volume_type     = var.root_volume_type
  root_volume_size     = var.root_volume_size
  delete_on_termination = var.delete_on_termination
  tags                 = var.tags
  environment          = var.environment

  iam_instance_profile_name = aws_iam_instance_profile.firewall.name
}
