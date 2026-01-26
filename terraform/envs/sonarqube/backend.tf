terraform {
    backend "s3" {
        bucket = "adex-terraform-states-248628534734u56"
        key = "sonarqube/terraform.tfstate"
        region = "eu-north-1"
    }
}