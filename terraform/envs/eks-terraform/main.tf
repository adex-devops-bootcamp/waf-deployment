module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_azs           = var.public_azs
  public_subnets_cidrs = var.public_subnets_cidrs
}

module "eks_cluster" {
  source            = "./modules/eks"
  eks_cluster_name  = var.eks_cluster_name
  public_subnet_ids = module.vpc.public_subnet_ids

  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_capacity_type  = var.node_capacity_type
}
