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

resource "aws_iam_role_policy" "connector_EKSDescribe" {
  name = "connector_EKSDescribe"
  role = aws_iam_role.border0-connector-role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "connector_ECSDescribe" {
  name = "connector_ECSDescribe"
  role = aws_iam_role.border0-connector-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeClusters",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "ecs:ListClusters",
          "ecs:ListContainerInstances",
          "ecs:ListServices",
          "ecs:ListTaskDefinitionFamilies",
          "ecs:ListTaskDefinitions",
          "ecs:ListTasks",
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

resource "aws_iam_role_policy" "connector_EC2Describe" {
  name = "connector_EC2Describe"
  role = aws_iam_role.border0-connector-role.id

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "ec2:Describe*",
			"Resource": "*"
		}
	]
}
EOF
}

resource "aws_iam_role_policy" "connector_RDSDescribe" {
  name = "connector_RDSDescribe"
  role = aws_iam_role.border0-connector-role.id

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "rds:Describe*",
			"Resource": "*"
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
        "arn:aws:ssm:*:*:parameter/aws/*",
        "arn:aws:ssm:*:*:parameter/border0/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "connector_SSMDescribePlus" {
  name = "connector_SSMDescribePlus"
  #   description = "Grants all access to SSM"
  role = aws_iam_role.border0-connector-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeParameters",
        "ssm:DescribeInstanceInformation",
        "ssm:TerminateSession"
      ],
      "Resource": [
        "arn:aws:ssm:*"
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
  name = var.prefix != "" ? "${var.prefix}-connector-role" : "Border0-example-connector-role"

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
  name = var.prefix != "" ? "${var.prefix}-Connector-profile" : "Border0-example-Connector-profile"
  role = aws_iam_role.border0-connector-role.name
}
