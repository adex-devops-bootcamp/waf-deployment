terraform {
    backend "s3" {
        bucket = "adex-terraform-248628534734u568934547435"
        key = "sonarqube/terraform.tfstate"
        region = "eu-north-1"
    }

}
