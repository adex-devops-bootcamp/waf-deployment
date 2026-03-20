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
  map_public_ip_on_launch = var.map_public_ip_on_launch

  # Private subnets
  number_of_private_subnets  = var.number_of_private_subnets
  private_subnets_cidr_block = var.private_subnets_cidr_block
}


module "eks_cluster" {
  source = "./Controlplane"

  cluster_name        = var.cluster_name
  authentication_mode = var.authentication_mode
  eks_version         = var.eks_version
  subnet_ids          = module.vpc.public_subnets
  tags                = var.tags
}

module "admin_access" {
  source       = "./Adminaccess"
  cluster_name = var.cluster_name
  admin_list   = var.admin_list
  tags         = var.tags
}
