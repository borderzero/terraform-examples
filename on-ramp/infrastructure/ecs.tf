# ECS Cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster"

  tags = merge(
    { Name = "${var.name_prefix}-ecs-cluster" },
    var.default_tags,
  )
}

# ECS Task Definition
resource "aws_ecs_task_definition" "ecs-buntu-container" {
  family                   = "ecs-buntu-container"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name    = "ubuntu-container"
    image   = "ubuntu:latest"
    command = ["tail", "-f", "/dev/null"]
    linuxParameters = {
      initProcessEnabled = true
    }
  }])

  tags = merge(
    { Name = "${var.name_prefix}-ecs-task" },
    var.default_tags,
  )
}

# ECS Service
resource "aws_ecs_service" "ecs-service" {
  name                   = "ecs-service"
  cluster                = aws_ecs_cluster.ecs-cluster.id
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.ecs-buntu-container.arn
  desired_count          = 3
  enable_execute_command = true
  network_configuration {
    assign_public_ip = false
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
  }

  tags = merge(
    { Name = "${var.name_prefix}-ecs-service" },
    var.default_tags,
  )
}


resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

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

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

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


# resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_attachment" {
#   role       = aws_iam_role.ecs_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }


resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


