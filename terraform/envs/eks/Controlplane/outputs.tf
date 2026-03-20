output "eks_api" {
  description = "Cluster api endpoint"
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_certificate" {
    description = "Cluster certificate"
    value = aws_eks_cluster.eks_cluster.certificate_authority
}