# SOnarqube Security Group
resource "aws_security_group" "sonarqube_sg" {
  name        = "sonarqube-sg"
  description = "Security group for SonarQube EC2"
  vpc_id      = aws_vpc.sonar_vpc.id

  tags = {
    Name = "${var.environment}-sonarqube-sg"
  }
}
resource "aws_security_group_rule" "ssh_to_private" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.sonarqube_sg.id
}

resource "aws_security_group_rule" "sonarqube_ingress" {
  type                     = "ingress"
  from_port                = 9000
  to_port                  = 9000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.sonarqube_sg.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sonarqube_sg.id
}


# Bastion Host Security Group
resource "aws_security_group" "bastion_sg" {
  name   = "${var.environment}-bastion-sg"
  vpc_id = aws_vpc.sonar_vpc.id
}

resource "aws_security_group_rule" "ssh_from_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.my_ip_cidr]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}