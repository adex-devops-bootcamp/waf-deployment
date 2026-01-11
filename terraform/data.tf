# Dynamic Public IP Fetching
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Converting into CIDR Format
locals {
  my_ip_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}

# Fetching AMI for the instance
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}