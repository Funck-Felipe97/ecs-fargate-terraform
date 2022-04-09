resource "aws_vpc" "aws-fargate-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "aws-fargate-vpc"
  }
}

resource "aws_subnet" "subnet-01" {
  vpc_id     = aws_vpc.aws-fargate-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "aws-fargate-vpc-subnet"
  }
}

resource "aws_subnet" "subnet-02" {
  vpc_id     = aws_vpc.aws-fargate-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "aws-fargate-vpc-subnet"
  }
}

resource "aws_internet_gateway" "internal-gateway-01" {
  vpc_id = aws_vpc.aws-fargate-vpc.id
  tags = {
    Name = "aws-fargate-vpc-service-01"
  }
}

resource "aws_route_table" "route-table-01" {
  vpc_id = aws_vpc.aws-fargate-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internal-gateway-01.id
  }
}

resource "aws_route_table_association" "route-table-associtation-subnet-01" {
  subnet_id      = aws_subnet.subnet-01.id
  route_table_id = aws_route_table.route-table-01.id
}

resource "aws_route_table_association" "route-table-associtation-subnet-02" {
  subnet_id      = aws_subnet.subnet-02.id
  route_table_id = aws_route_table.route-table-01.id
}