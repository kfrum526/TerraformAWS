resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
      Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "AWSRT1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "AWSRT1"
  }
}

resource "aws_route_table_association" "igw_ass" {
  route_table_id = aws_route_table.AWSRT1.id
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "PubSub" {
  route_table_id = aws_route_table.AWSRT1.id
  subnet_id = aws_subnet.public.id
}
resource "aws_route_table_association" "PrivSub" {
  route_table_id = aws_route_table.AWSRT1.id
  subnet_id = aws_subnet.private.id
}

resource "aws_route" "igw" {
    route_table_id = aws_route_table.AWSRT1.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}