output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of EC2"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address of EC2"
  value       = aws_instance.this.private_ip
}

output "availability_zone" {
  description = "Availability Zone of EC2"
  value       = aws_instance.this.availability_zone
}

output "ec2_eip" {
  description = "Elastic IP of EC2"
  value       = aws_eip.firewall.public_ip
}
