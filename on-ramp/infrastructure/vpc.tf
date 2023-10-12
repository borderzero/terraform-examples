resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    { Name = "${var.name_prefix}-vpc" },
    var.default_tags,
  )
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${data.aws_region.current.name}a"  # First AZ
}
# Create additional private subnet in another AZ
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${data.aws_region.current.name}b"  # Second AZ
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${data.aws_region.current.name}c"  # Third AZ
}

resource "aws_subnet" "connector_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "${data.aws_region.current.name}d"  # Fourth/Connector AZ
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat_eip" {
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip.id
  tags = merge(
    { Name = "${var.name_prefix}-nat-gw" },
    var.default_tags,
  )
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association_4" {
  subnet_id      = aws_subnet.connector_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_security_group" "allow_all_vpc" {
  name        = "allow_all_vpc"
  description = "Allow all outbound traffic and selected inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow ICMP Echo requests"
    from_port   = 8
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow All from within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  # outbound internet access
  egress {
    description = "Allow ALL traffic out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




