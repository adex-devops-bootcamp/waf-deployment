# access entry
resource "aws_eks_access_entry" "admin_access_entry" {
  cluster_name      = var.cluster_name
  principal_arn     = aws_iam_role.eks_admin_role
  type              = "STANDARD"
}

# attach AmazonEKSClusterAdminPolicy
resource "aws_eks_access_policy_association" "Adminaccess" {
  cluster_name  = var.cluster_name
  policy_arn    = data.aws_iam_policy.eks_admin_policy.arn
  principal_arn = aws_iam_role.eks_admin_role

  access_scope {
    type       = "namespace"
  }
}