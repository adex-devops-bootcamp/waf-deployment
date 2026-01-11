output "sonarqube_private_ip" {
  description = "Private IP of SonarQube EC2 instance"
  value       = aws_instance.sonarqube.private_ip
}

output "sonarqube_sg_id" {
  description = "Security group ID for SonarQube"
  value       = aws_security_group.sonarqube_sg.id
}

output "sonarqube_subnet_id" {
  description = "Private subnet ID where SonarQube is deployed"
  value       = aws_instance.sonarqube.subnet_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.sonar_vpc.id
}

output "sonarqube_alb_dns_name" {
  description = "Public DNS name of the SonarQube Application Load Balancer"
  value       = aws_lb.sonarqube_alb.dns_name
}

output "sonarqube_url" {
  description = "SonarQube URL"
  value       = "http://${aws_lb.sonarqube_alb.dns_name}"
}

output "instance_public_ip" {
  description = "Public IP of bastion host"
  value = aws_instance.Bastion.public_ip
}