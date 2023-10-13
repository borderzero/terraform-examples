
# Your border0 conenctor EC2 instance configuration
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "connector_instance" {
  instance_type          = "t3.micro"
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = var.private_subnet_ids["private_subnet_id_1"]
  iam_instance_profile   = aws_iam_instance_profile.border0-connector-profile.name
  vpc_security_group_ids = [var.allow_all_vpc_id]
  user_data_base64 = base64encode(templatefile("${path.module}/user-data.tpl",
    {
      border0_connector_token_path = "from:aws:ssm:${var.smm-border0-token-path}"
  }))

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
  root_block_device {
    volume_type = "gp3"
  }

  tags = merge(
    { Name = "border0-example-connector" },
    var.default_tags,
  )
}
