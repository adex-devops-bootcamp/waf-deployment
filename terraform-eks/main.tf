provider "aws" {
  region = var.aws_region
}

# Fetch existing IAM roles
data "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"
}

data "aws_iam_role" "eks_node" {
  name = "eks-node-role"
}


module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  cluster_name    = var.cluster_name
}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets_ids
  cluster_role_arn = data.aws_iam_role.eks_cluster.arn
  node_role_arn    = data.aws_iam_role.eks_node.arn
  node_groups      = var.node_groups
  eks_admin_users  = var.eks_admin_users
}
