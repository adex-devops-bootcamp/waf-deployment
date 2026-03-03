# control plane
resource "aws_eks_cluster" "eks_cluster" {
    name = var.cluster_name

    access_config {
      authentication_mode = var.authentication_mode
    }

    role_arn = aws_iam_role.cluster_role.name
    version = var.eks_version

    vpc_config {
      subnet_ids = var.subnet_ids
    }

    # role must be created first
    depends_on = [
    aws_iam_role.cluster_role
  ]

  tags = merge(
    {Name = var.cluster_name},
    var.tags
  )
}