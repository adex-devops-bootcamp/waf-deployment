# ALB SG
resource "aws_security_group" "alb_sg" {
  name   = "${var.environment}-alb-sg"
  vpc_id = aws_vpc.sonar_vpc.id
}

resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# ALB
resource "aws_lb" "sonarqube_alb" {
  name               = "${var.environment}-sonarqube-alb"
  internal           = false
  load_balancer_type = "application"

  subnets         = aws_subnet.public[*].id
  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Environment = var.environment
  }
}

# Target Group
resource "aws_lb_target_group" "sonarqube_tg" {
  name     = "${var.environment}-sonarqube-tg"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = aws_vpc.sonar_vpc.id

  health_check {
    path                = "/"
    port                = "9000"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }
}

# Attach Target Group
resource "aws_lb_target_group_attachment" "sonarqube_attach" {
  target_group_arn = aws_lb_target_group.sonarqube_tg.arn
  target_id        = aws_instance.sonarqube.id
  port             = 9000
}

# ALB Listner
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.sonarqube_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube_tg.arn
  }
}
