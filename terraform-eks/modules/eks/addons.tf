resource "aws_eks_addon" "cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kubeproxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"
}
