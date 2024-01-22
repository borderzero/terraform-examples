# ECS Cluster
resource "aws_ecs_cluster" "ecs-cluster1" {
  name = "ecs-cluster1"

  tags = merge(
    { Name = "${var.prefix}-ecs-cluster1" },
    var.default_tags,
  )
}

# ECS Task Definition
resource "aws_ecs_task_definition" "ecs-nginx-container" {
  family                   = "ecs-nginx-container"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_ngx_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_ngx_task_role.arn
  container_definitions = jsonencode([{
    name  = var.prefix != "" ? "${var.prefix}-ngx-container" : "Border0-example-ngx-container"
    image = "nginxdemos/hello",
    portMappings = [{
      containerPort = 80,
      hostPort      = 80,
      protocol      = "tcp"
    }]
  }])

  tags = merge(
    { Name = "${var.prefix}-ngx-ecs-task" },
    var.default_tags,
  )
}

# ECS Service
resource "aws_ecs_service" "ecs-service1" {
  name                   = "ecs-service1"
  cluster                = aws_ecs_cluster.ecs-cluster1.id
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.ecs-nginx-container.arn
  desired_count          = 2
  enable_execute_command = true
  network_configuration {
    assign_public_ip = false
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_1.id]
    security_groups  = [aws_security_group.allow_all_vpc.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_alb_target_group.arn
    container_name   = var.prefix != "" ? "${var.prefix}-ngx-container" : "Border0-example-ngx-container" # Updated to match container name in task definition
    container_port   = 80
  }

  tags = merge(
    { Name = "${var.prefix}-ecs-service1" },
    var.default_tags,
  )
}


# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_ngx_execution_role" {
  name = var.prefix != "" ? "${var.prefix}-ecs-ngx-exec-role" : "Border0-example-ecs-ngx-exec-role"

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
resource "aws_iam_role" "ecs_ngx_task_role" {
  name = var.prefix != "" ? "${var.prefix}-ecs-ngx-task-role" : "Border0-example-ecs-ngx-task-role"

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


resource "aws_iam_role_policy" "ecs_ngx_task_role_SSMConsole" {
  name = "ecs_ngx_task_role_SSMConsole"
  # description = "Grants all access to RDS DB based on AIM auth"
  role = aws_iam_role.ecs_ngx_task_role.name

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

