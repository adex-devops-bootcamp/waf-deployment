# Mandatory EKS add-ons for a working cluster on Kubernetes 1.31

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = var.cluster_name
  addon_name        = "vpc-cni"
  addon_version     = "v1.18.3-eksbuild.3"   # latest stable for 1.31 as of early 2026 – verify with AWS CLI
 resolve_conflicts_on_update  = "PRESERVE"

  depends_on = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = "v1.11.3-eksbuild.1"   # latest stable for 1.31
  resolve_conflicts_on_update  = "PRESERVE"

  depends_on = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = var.cluster_name
  addon_name        = "kube-proxy"
  addon_version     = "v1.31.0-eksbuild.5"   # matches 1.31 series
  resolve_conflicts_on_update  = "PRESERVE"

  depends_on = [aws_eks_cluster.eks_cluster]
}