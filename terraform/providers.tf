terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "SonarQube"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}
