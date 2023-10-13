# ECS Cluster
resource "aws_ecs_cluster" "ecs-cluster1" {
  name = "ecs-cluster1"

  tags = merge(
    { Name = "${var.prefix}-ecs-cluster1" },
    var.default_tags,
  )
}

# ECS Task Definition
resource "aws_ecs_task_definition" "ecs-ubuntu-container" {
  family                   = "ecs-ubuntu-container"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name = var.prefix != "" ? "${var.prefix}-container" : "Border0-example-container"
    image   = "ubuntu:latest"
    command = ["tail", "-f", "/dev/null"]
    linuxParameters = {
      initProcessEnabled = true
    }
  }])

  tags = merge(
    { Name = "${var.prefix}-ecs-task" },
    var.default_tags,
  )
}

# ECS Service
resource "aws_ecs_service" "ecs-service1" {
  name                   = "ecs-service1"
  cluster                = aws_ecs_cluster.ecs-cluster1.id
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.ecs-ubuntu-container.arn
  desired_count          = 2
  enable_execute_command = true
  network_configuration {
    assign_public_ip = false
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  }

  tags = merge(
    { Name = "${var.prefix}-ecs-service1" },
    var.default_tags,
  )
}


# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = var.prefix != "" ? "${var.prefix}-ecs-exec-role" : "Border0-example-ecs-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name = var.prefix != "" ? "${var.prefix}-ecs-task-role" : "Border0-example-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "ecs_task_role_SSMConsole" {
  name = "ecs_task_role_SSMConsole"
  # description = "Grants all access to RDS DB based on AIM auth"
  role = aws_iam_role.ecs_task_role.name

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

