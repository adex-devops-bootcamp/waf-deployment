resource "aws_iam_role" "eks_admin_role" {
  name = "${var.cluster_name}-eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.admin_list
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    { Name = "${var.cluster_name}-eks-admin-role" },
    var.tags
  )
}
