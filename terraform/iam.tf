############################
# IAM Role for EC2
############################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firewall_ec2_role" {
  name               = "${var.environment}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(
    var.tags,
    { Name = "${var.environment}-ec2-role" }
  )
}

############################
# IAM Policies Attachments
############################

# SSM access (Session Manager)
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.firewall_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# CloudWatch logs & metrics
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.firewall_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

############################
# Instance Profile
############################

resource "aws_iam_instance_profile" "firewall" {
  name = "${var.environment}-instance-profile"
  role = aws_iam_role.firewall_ec2_role.name
}