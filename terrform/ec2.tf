# resource for SonarQube Server

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]
  key_name               = var.ec2_key_name

  root_block_device {
    volume_type        = "gp3"
    volume_size        = 20
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-sonarqube-ec2"
  }

  user_data = <<-EOF
  #!/bin/bash
  set -e

  sudo apt update
  sudo apt install ca-certificates curl software-properties-common

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  systemctl enable --now docker

  # Run Sonar AFTER boot stabilizes
  (sleep 60 && docker run -d \
    --name sonarqube \
    -p 9000:9000 \
    -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
    --restart unless-stopped \
    sonarqube:lts) &
  EOF
}

# Resource for Bastion Host

resource "aws_instance" "Bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public[0].id # Public subnet
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.ec2_key_name
  associate_public_ip_address = true
}