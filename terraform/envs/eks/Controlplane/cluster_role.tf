# cluster_role for control plane
resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  # Trust policy for eks_cluster to assume cluster_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    {Name = "${var.cluster_name}-cluster-role"},
    var.tags
  )
  
}

# Attach eks_cluster_policy to cluster_role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    role = aws_iam_role.cluster_role
    policy_arn = data.aws_iam_policy.eks_cluster_policy.arn
}