# fetch arn of AmazonEKSClusterAdminPolicy
data "aws_iam_policy" "eks_admin_policy" {
  name = "AmazonEKSClusterAdminPolicy"
}