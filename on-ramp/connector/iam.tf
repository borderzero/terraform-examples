# IAM Policy
resource "aws_iam_role_policy" "connector_SSHPushKey" {
  name = "connector_SSHPushKey"
  role = aws_iam_role.border0-connector-role.id
  # description = "Policy for allowing SendSSHPublicKey operations"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ec2-instance-connect:SendSSHPublicKey",
        "Resource" : [
          "arn:aws:ec2:*:*:instance/*"
        ],
        "Condition" : {
          "StringEquals" : {
            "ec2:osuser" : "ubuntu"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "connector_describeECS" {
  name = "connector_describeECS"
  role = aws_iam_role.border0-connector-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:ListTasks",
          "ecs:DescribeTasks",
          "ecs:DescribeClusters",
          "ecs:ListClusters",
          "ssm:StartSession",
          "iam:SimulatePrincipalPolicy" # required for simulating principal policy operation
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "connector_RDSConnect" {
  name = "connector_RDSConnect"
  # description = "Grants all access to RDS DB based on AIM auth"
  role = aws_iam_role.border0-connector-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "rds-db:connect",
      "Resource": [
      "arn:aws:rds-db:*:*:dbuser:*/Border0ConnectorRDSUser",
      "arn:aws:rds-db:*:*:dbuser:*/Border0ConnectorUser",
      "arn:aws:rds-db:*:*:dbuser:*/Border0Connector"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "connector_SSMAccess" {
  name = "connector_SSMAccess"
  role = aws_iam_role.border0-connector-role.id
  # description = "Becasue AmazonSSMManagedInstanceCore is too permissive we are explicitly allowing access to only the parameters we need"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ],
      "Resource": [
        "arn:aws:ssm:*:*:parameter/border0/*"
      ]
    }
  ]
}
EOF
}



resource "aws_iam_role_policy" "connector_SSMConsole" {
  name = "connector_SSMConsole"
  # description = "Grants all access to RDS DB based on AIM auth"
  role = aws_iam_role.border0-connector-role.id

  policy = <<EOF
{
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
}
EOF
}

# IAM Role
resource "aws_iam_role" "border0-connector-role" {
  name = "border0-connector-role"

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

# IAM Instance Profile
resource "aws_iam_instance_profile" "border0-connector-profile" {
  name = "border0-connector-profile"
  role = aws_iam_role.border0-connector-role.name
}
