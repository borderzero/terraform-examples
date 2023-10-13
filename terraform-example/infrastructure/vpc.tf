resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    { Name = "${var.prefix}-vpc" },
    var.default_tags,
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

# resource "aws_subnet" "private_subnet_1" {
#   count             = 1
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = element(var.subnet_cidrs, count.index)
#   availability_zone = element(data.aws_availability_zones.available.names, count.index)

#   tags = {
#     Name = "private-subnet-1"
#   }
# }



resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  tags = merge(
    { Name = "${var.prefix}-public-subnet" },
    var.default_tags,
  )
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, 0) # First AZ
  tags = merge(
    { Name = "${var.prefix}-private-subnet-1" },
    var.default_tags,
  )
}
# Create additional private subnet in another AZ
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, 1) # Second AZ
  tags = merge(
    { Name = "${var.prefix}-private-subnet-2" },
    var.default_tags,
  )
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    { Name = "${var.prefix}-igw" },
    var.default_tags,
  )
}

resource "aws_eip" "nat_eip" {
  tags = merge(
    { Name = "${var.prefix}-nat-gw-eip" },
    var.default_tags,
  )
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip.id
  tags = merge(
    { Name = "${var.prefix}-nat-gw" },
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
  tags = merge(
    { Name = "${var.prefix}-public-rt" },
    var.default_tags,
  )
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
  tags = merge(
    { Name = "${var.prefix}-private-rt" },
    var.default_tags,
  )
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
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




