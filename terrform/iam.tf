# # IAM Role for EC2 (SonarQube)

# # Assume Role Policy for EC2
# data "aws_iam_policy_document" "ec2_assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# # IAM Role
# resource "aws_iam_role" "sonarqube_ec2_role" {
#   name               = "${var.environment}-ec2-role"
#   assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

#   tags = merge(
#     var.tags,
#     {
#       Name    = "${var.environment}-ec2-role"
#       Project = "SonarQube"
#     }
#   )
# }


# # Attach AWS-Managed Policies

# # SSM Session Manager (SSH-less access)
# resource "aws_iam_role_policy_attachment" "ssm" {
#   role       = aws_iam_role.sonarqube_ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# # CloudWatch Logs & Metrics
# resource "aws_iam_role_policy_attachment" "cloudwatch" {
#   role       = aws_iam_role.sonarqube_ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
# }

# #########################################
# # IAM Instance Profile for EC2
# #########################################

# resource "aws_iam_instance_profile" "sonarqube" {
#   name = "${var.environment}-instance-profile"
#   role = aws_iam_role.sonarqube_ec2_role.name
# }
 