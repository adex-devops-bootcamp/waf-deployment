# SonarQube Server

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]
  key_name               = var.ec2_key_name

  root_block_device {
    volume_type          = "gp3"
    volume_size          = 20
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-sonarqube-ec2"
  }

  # user_data = <<-EOF
  #   #!/bin/bash
  #   set -e
  #   # Minimal packages to avoid user_data failure
  #   sudo apt update -y
    
  # EOF

  # Provisioner to run via Bastion
  provisioner "remote-exec" {
    inline = [
      # Wait for apt locks to be free (cloud-init may lock)
      "sudo apt update -y",
      "sudo apt install -y ca-certificates curl software-properties-common lsb-release gnupg",
      "while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do echo 'Waiting for apt lock...'; sleep 5; done",
      "sudo apt update -y",
      "sudo apt install -y ca-certificates curl software-properties-common lsb-release gnupg",

      # Docker repo setup
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
      "ARCH=$(dpkg --print-architecture)",
      "CODENAME=$(lsb_release -cs)",
      "echo \"deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $CODENAME stable\" | sudo tee /etc/apt/sources.list.d/docker.list",

      # Install Docker
      "sudo apt update -y",
      "sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo systemctl enable --now docker",

      # Run SonarQube container
      "sudo docker run -d --name sonarqube -p 9000:9000 -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true --restart unless-stopped sonarqube:lts"
    ]

    connection {
      type        = "ssh"
      host        = self.private_ip
      user        = "ubuntu"
      private_key = file(var.ec2_key_path)
      bastion_host = aws_instance.Bastion.public_ip
      bastion_user = "ubuntu"
    }
  }
}

# Bastion Host

resource "aws_instance" "Bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.ec2_key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-Bastion-Host-ec2"
  }
}
