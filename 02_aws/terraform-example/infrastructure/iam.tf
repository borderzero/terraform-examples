# IAM Policy
resource "aws_iam_policy" "ssm_policy" {
  name        = var.prefix != "" ? "${var.prefix}-PartielSMMAllowPolicy" : "Border0-example-PartielSMMAllowPolicy"
  description = "Policy for allowing SSM operations"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : ["ssm:StartSession", "ssm:TerminateSession", "ssm:ResumeSession"],
        "Effect" : "Allow",
        "Resource" : ["arn:aws:ec2:*:*:instance/*", "arn:aws:ecs:*:*:task/*"]
      },
      {
        "Action" : ["ssm:UpdateInstanceInformation"],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : ["ssmmessages:CreateControlChannel", "ssmmessages:CreateDataChannel", "ssmmessages:OpenControlChannel", "ssmmessages:OpenDataChannel"],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = var.prefix != "" ? "${var.prefix}-EC2-role" : "Border0-example-EC2-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.prefix != "" ? "${var.prefix}-EC2-profile" : "Border0-example-EC2-profile"
  role = aws_iam_role.ec2_role.name
}
