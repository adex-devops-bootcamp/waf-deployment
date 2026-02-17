
# Fetch existing IAM roles from CloudFormation

data "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
}

data "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"
}

data "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
}


# Create EKS cluster (control plane only)

resource "aws_eks_cluster" "eks" {
  name     = var.eks_cluster_name
  role_arn = data.aws_iam_role.eks_cluster_role.arn
  upgrade_policy {
  support_type = "STANDARD"
}

  vpc_config {
    subnet_ids = var.public_subnet_ids
  }

  depends_on = [
    data.aws_iam_role.eks_admin_role
  ]
}


resource "aws_eks_node_group" "managed_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.eks_cluster_name}-nodes"
  node_role_arn   = data.aws_iam_role.eks_node_role.arn
  subnet_ids      = var.public_subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = var.node_instance_types
  capacity_type  = var.node_capacity_type

  depends_on = [
    aws_eks_cluster.eks
  ]
}