resource "aws_vpc" "flasky_vpc" {
  cidr_block            = "10.1.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  
  tags = {
    "Name" = "Flasky VPC"
  }

}

resource "aws_internet_gateway" "flasky_gateway" {
  vpc_id = aws_vpc.flasky_vpc.id
  tags = {
    "Name" = "Flasky Gateway"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id 		    = aws_vpc.flasky_vpc.id
  cidr_block		= "10.1.0.0/20"
  availability_zone	= "us-west-2a"
  tags = {
    "Name" = "Flasky Private Subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id 		    = aws_vpc.flasky_vpc.id
  cidr_block		= "10.1.16.0/20"
  availability_zone	= "us-west-2b"
  tags = {
    "Name" = "Flasky Private Subnet 2"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id        = aws_vpc.flasky_vpc.id
  cidr_block    = "10.1.35.0/24"
  availability_zone = "us-west-2a"
  tags = {
    "Name" = "Flasky Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id        = aws_vpc.flasky_vpc.id
  cidr_block    = "10.1.36.0/24"
  availability_zone = "us-west-2b"
  tags = {
    "Name" = "Flasky Public Subnet 2"
  }
}

resource "aws_default_route_table" "main_route_table" {
  default_route_table_id = aws_vpc.flasky_vpc.default_route_table_id

  tags = {
    Name = "Main Route Table"
  }
}

resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.flasky_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flasky_gateway.id
  }

    tags = {
    Name = "Public Routes"
  }
}

resource "aws_route_table_association" "public_route_assoc_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table_association" "public_route_assoc_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_routes.id
}

output "vpc_id" {
    value = aws_vpc.flasky_vpc.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}