
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}


provider "aws" {
   region = var.aws_region
   access_key = var.access_key
   secret_key = var.secret_key


#  access_key = data.aws_ssm_parameter.terraform_access_key_id.value
#  secret_key = data.aws_ssm_parameter.terraform_secret_access_key.value
}
#provider "aws" {
#  alias   = "ssm"
#  region  = var.aws_region
#  profile = "default" # admin profile
#}
# Fetch secrets from SSM Parameter Store
#data "aws_ssm_parameter" "terraform_access_key_id" {
#  name = "/terraform/user/access_key_id"
#  provider = aws.ssm
#}

#data "aws_ssm_parameter" "terraform_secret_access_key" {
#  name            = "/terraform/user/secret_access_key"
# with_decryption = true
#  provider = aws.ssm
#}
  