############################
# AMI Lookup
############################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

############################
# EC2 Instance
############################

resource "aws_instance" "this" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile   = aws_iam_instance_profile.firewall.name
  key_name = var.key_name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    iops                  = 3000 # Baseline IOPS for gp3 (included at no extra cost)
    throughput            = 125  # Baseline throughput in MB/s for gp3 (included at no extra cost)
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits = "standard"
  }

  tags = merge(
    var.tags,
    { Name = "${var.environment}-ec2" }
  )
}

######## Attaching EIP to the instance #############
resource "aws_eip" "this" {
  instance = aws_instance.this.id
  domain   = "vpc"
}