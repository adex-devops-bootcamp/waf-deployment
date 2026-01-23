terraform {
    backend "s3" {
        bucket = "adex-terraform-states"
        key = "sonarqube/terraform.tfstate"
        region = "eu-north-1"
    }
}