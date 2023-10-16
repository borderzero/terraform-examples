resource "border0_socket" "alb_http_socket1" {
  name                             = "nginx-webserver1"
  recording_enabled                = true
  socket_type                      = "http"
  connector_id                     = var.border0_connector_id
  connector_authentication_enabled = false
  
  http_configuration {
    upstream_url = "http://${var.alb["alb_dns_name"]}"
  }

  tags = merge({
    border0_client_category    = "Terraform Example",
    border0_client_subcategory = data.aws_region.current.name,
    border0_client_icon        = "nonicons:nginx-16",
    provider_type              = "aws",
    border0_client_icon_text   = "${var.alb["alb_dns_name"]}",
  }, var.default_tags)
}


resource "border0_socket" "connect_to_ecs1_with_ssm" {
  name                             = var.ecs["cluster1"]["cluster_name"]
  recording_enabled                = true
  socket_type                      = "ssh"
  connector_id                     = var.border0_connector_id
  connector_authentication_enabled = true
  ssh_configuration {
    service_type       = "aws_ssm"
    ssm_target_type    = "ecs"
    ecs_cluster_region = data.aws_region.current.name
    ecs_cluster_name   = var.ecs["cluster1"]["cluster_name"]
    ecs_service_name   = var.ecs["cluster1"]["service_name"]
  }

  tags = merge({
    border0_client_category    = "Terraform Example",
    border0_client_subcategory = data.aws_region.current.name,
    border0_client_icon        = "simple-icons:amazonecs",
    provider_type              = "aws",
    border0_client_icon_text   = var.ecs["cluster1"]["service_name"],
  }, var.default_tags)
}


resource "border0_policy_attachment" "ecs_socket_policy_attachment1" {
  policy_id = var.border0_policy_id
  socket_id = border0_socket.connect_to_ecs1_with_ssm.id
}



resource "border0_socket" "rds" {
  name                             = "rds-${data.aws_region.current.name}"
  description                      = "DB Socket for RDS in ${data.aws_region.current.name}"
  recording_enabled                = true
  socket_type                      = "database"
  connector_id                     = var.border0_connector_id
  connector_authentication_enabled = true

  database_configuration {
    protocol            = "mysql"
    service_type        = "aws_rds"
    authentication_type = "username_and_password"
    rds_instance_region = data.aws_region.current.name
    hostname            = var.rds_instance["address"]
    port                = var.rds_instance["port"]
    username            = var.rds_instance["username_path"]
    password            = var.rds_instance["password_path"]
  }
  tags = merge({
    border0_client_category    = "Terraform Example",
    border0_client_subcategory = data.aws_region.current.name,
    border0_client_icon        = "simple-icons:amazonrds",
    provider_type              = "aws",
  }, var.default_tags)
}

resource "border0_policy_attachment" "rds_policy_attachment" {
  policy_id = var.border0_policy_id
  socket_id = border0_socket.rds.id
}


resource "border0_socket" "ec2-instance" {
  for_each = var.ec2_instances

  name                             = "${each.key}-${data.aws_region.current.name}"
  description                      = "SSH Socket for ${each.key}-${data.aws_region.current.name}"
  recording_enabled                = true
  connector_authentication_enabled = true
  socket_type                      = "ssh"
  connector_id                     = var.border0_connector_id

  ssh_configuration {
    service_type        = "aws_ec2_instance_connect"
    hostname            = each.value["private_ip"] # Updated from "address" to "private_ip" based on your module output
    port                = 22
    username_provider   = "defined"
    username            = "ubuntu"
    ec2_instance_id     = each.value["id"]
    ec2_instance_region = data.aws_region.current.name
  }
  tags = merge({
    border0_client_category    = "Terraform Example",
    border0_client_subcategory = data.aws_region.current.name,
    border0_client_icon        = "simple-icons:amazonec2",
    provider_type              = "aws",
  }, var.default_tags)
}


resource "border0_policy_attachment" "ec2_instances_policy_attachment" {
  for_each = border0_socket.ec2-instance

  policy_id = var.border0_policy_id
  socket_id = each.value.id
}
