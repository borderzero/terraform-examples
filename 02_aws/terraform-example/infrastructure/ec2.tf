# Your regular EC2 instance configuration
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

resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.nano"
  subnet_id              = element([aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id], count.index % 2)
  vpc_security_group_ids = [aws_security_group.allow_all_vpc.id]

  count                = 2
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_type = "gp3"
  }
  tags = merge(
    { Name = "${var.prefix}-ec2_instance${format("%02d", count.index + 1)}" },
    var.default_tags,
  )
}

