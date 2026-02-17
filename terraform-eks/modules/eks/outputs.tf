output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}
# Cluster endpoint
output "cluster_endpoint" {
  description = "API endpoint for the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

# Cluster certificate authority
output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}


# Cluster security group (auto-created by EKS)
output "cluster_security_group_id" {
  description = "Security Group ID of the EKS cluster control plane"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

# Node group security groups (worker nodes)
output "node_security_group_ids" {
  description = "List of security groups associated with EKS managed node groups"
  value       = flatten([for ng in aws_eks_node_group.this : ng.resources_vpc_config[0].security_group_ids])
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}


# Kubeconfig YAML (for kubectl)
output "kubeconfig" {
  description = "Kubeconfig for the EKS cluster"
  value = <<EOT
apiVersion: v1
clusters:
  - cluster:
    server: ${aws_eks_cluster.this.endpoint}
    certificate-authority-data: ${aws_eks_cluster.this.certificate_authority[0].data}
  name: ${aws_eks_cluster.this.name}
contexts:
  - context:
    cluster: ${aws_eks_cluster.this.name}
    user: aws
  name: ${aws_eks_cluster.this.name}
current-context: ${aws_eks_cluster.this.name}
users:
  - name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${aws_eks_cluster.this.name}"
EOT
}

