resource "aws_eip" "nat_gateway_1_ip" {
  vpc = true
}

resource "aws_eip" "nat_gateway_2_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1_ip.id
  subnet_id = var.public_subnet_1_id
  tags = {
    "Name" = "Flasky Nat Gateway 1"
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_2_ip.id
  subnet_id = var.public_subnet_2_id
  tags = {
    "Name" = "Flasky Nat Gateway 2"
  }
}

resource "aws_route_table" "nat_route_table_1" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }

  tags = {
    Name = "Private Routes"
  }
}

resource "aws_route_table" "nat_route_table_2" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }

  tags = {
    Name = "Private Routes"
  }
}

resource "aws_route_table_association" "subnet_1_assoc" {
  subnet_id = var.private_subnet_1_id
  route_table_id = aws_route_table.nat_route_table_1.id
}

resource "aws_route_table_association" "subnet_2_assoc" {
  subnet_id = var.private_subnet_2_id
  route_table_id = aws_route_table.nat_route_table_2.id
}