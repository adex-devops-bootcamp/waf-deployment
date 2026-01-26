terraform {
  backend "s3" {
    bucket = "adex-terraform-248628534734u568934547435"
    key = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}