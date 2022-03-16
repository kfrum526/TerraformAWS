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

 tags = {
     Name = "Public Subnet"
 } 
}

resource "aws_subnet" "private" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.2.0/24"
 availability_zone = "us-east-1b"

 tags = {
     Name = "Private Subnet"
 } 
}