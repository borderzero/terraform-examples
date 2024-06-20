# Application Load Balancer
resource "aws_lb" "nginx_alb" {
  name               = "${var.prefix}-alb"
  internal           = true # Set this to true for a private ALB
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.alb_sg.id]
  security_groups = [aws_security_group.allow_all_vpc.id]
  subnets         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = merge(
    { Name = "${var.prefix}-alb" },
    var.default_tags,
  )
}

# Target Group for ALB
resource "aws_lb_target_group" "nginx_alb_target_group" {
  name        = "${var.prefix}-atg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip" # Specify target type as 'ip'

  tags = merge(
    { Name = "${var.prefix}-atg" },
    var.default_tags,
  )
}

# Listener for ALB
resource "aws_lb_listener" "nginx_alb_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_alb_target_group.arn
  }

  tags = merge(
    { Name = "${var.prefix}-nginx-listener" },
    var.default_tags,
  )
}
