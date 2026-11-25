resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW-${terraform.workspace}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.pub_subnets)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-${terraform.workspace}-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.priv_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.priv_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Private-${terraform.workspace}-${count.index}"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "NAT-EIP-${terraform.workspace}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NAT-${terraform.workspace}"
  }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  subnet_ids = concat(
    aws_subnet.public[*].id,
    aws_subnet.private[*].id,
  )

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "NACL-${terraform.workspace}"
  }
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT-Public-${terraform.workspace}"
  }
}

resource "aws_route_table" "priv" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "RT-Private-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "pub" {
  count = length(var.pub_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "priv" {
  count = length(var.priv_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.priv.id
}
