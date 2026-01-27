data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "adex-terraform-248628534734u568934547435"
    key    = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}
