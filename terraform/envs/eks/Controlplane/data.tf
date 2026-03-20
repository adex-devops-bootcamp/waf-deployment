# fetching arn of AmazonEKSClusterPolicy
data "aws_iam_policy" "eks_cluster_policy" {
    name = "AmazonEKSClusterPolicy" 
}