resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = merge(
    { Name = "${var.prefix}-rds-subnet-group" },
    var.default_tags,
  )
}


# we want to generate a fairly strong and rather long DB password and username, it will be put into SSM:/border0/demo-rds-* parameters
resource "random_password" "random-rds-password" {
  length           = 32
  special          = true
  override_special = "#-:"
}

resource "random_password" "random-rds-username" {
  length  = 12
  special = false
}

locals {
  rds_username = "RDS${random_password.random-rds-username.result}"
  rds_password = "PASS${random_password.random-rds-password.result}"
}

resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  storage_type         = "gp3"
  identifier           = var.prefix != "" ? "${var.prefix}-rds" : "Border0-Example-RDS"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = local.rds_username
  password             = local.rds_password
  parameter_group_name = "default.mysql5.7"
  db_name              = "border0"

  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_all_vpc.id]
  #
  iam_database_authentication_enabled = true

  tags = merge(
    { Name = "${var.prefix}-rds" },
    var.default_tags,
  )
}

# SSM secret parameter for the connector to consume, will contain RDS credentials
resource "aws_ssm_parameter" "border0-rds-username" {
  name        = var.smm-db-username-path
  description = "Border0 demo Database pass"
  type        = "SecureString"
  depends_on  = [random_password.random-rds-username]
  value       = local.rds_username
  # in case of ParameterAlreadyExists error for aws_ssm_parameters
  # https://github.com/hashicorp/terraform-provider-aws/issues/25636 and https://github.com/hashicorp/terraform-provider-aws/issues/32736
  # overwrite = true
  tags = merge(
    { Name = "${var.prefix}-parameter" },
    var.default_tags,
  )
}
resource "aws_ssm_parameter" "border0-rds-password" {
  name        = var.smm-db-password-path
  description = "Border0 demo Database pass"
  type        = "SecureString"
  depends_on  = [random_password.random-rds-password]
  value       = local.rds_password
  # in case of ParameterAlreadyExists error for aws_ssm_parameters
  # https://github.com/hashicorp/terraform-provider-aws/issues/25636 and https://github.com/hashicorp/terraform-provider-aws/issues/32736
  # overwrite = true
  tags = merge(
    { Name = "${var.prefix}-parameter" },
    var.default_tags,
  )
}
