provider "aws" {
  region = "eu-west-3"
}
#Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Bozho-test-VPC"
  }
}

#Create subnets for the VPC
resource "aws_subnet" "subnet_az1_public_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_az1_public_1"
  }
}

resource "aws_subnet" "subnet_az1_public_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_az1_public_2"
  }
}

resource "aws_subnet" "subnet_az2_public_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_az2_public_1"
  }
}

resource "aws_subnet" "subnet_az2_public_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_az2_public_2"
  }
}

#create route table for the subnets to route traffic to IGW
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_route_table"
  }
}

#Attach route table association to the subnets so they can reach IGW
resource "aws_route_table_association" "my_association_az1_public_1" {
  subnet_id      = aws_subnet.subnet_az1_public_1.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_association_az1_public_2" {
  subnet_id      = aws_subnet.subnet_az1_public_2.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_association_az2_public_1" {
  subnet_id      = aws_subnet.subnet_az2_public_1.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_association_az2_public_2" {
  subnet_id      = aws_subnet.subnet_az2_public_2.id
  route_table_id = aws_route_table.my_route_table.id
}

#Of course I need private subnets as well xD
resource "aws_subnet" "subnet_az1_private_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "subnet_az1_private_1"
  }
}

resource "aws_subnet" "subnet_az2_private_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    Name = "subnet_az2_private_1"
  }
}

#Another route table for the private subnets
resource "aws_route_table" "my_private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.myNATgw.id
  }

  tags = {
    Name = "my_private_route_table"
  }
}

#Route table association that points to the MyNATgw so resources in my private subnet can reach the Internet
resource "aws_route_table_association" "my_association_az1_private_1" {
  subnet_id      = aws_subnet.subnet_az1_private_1.id
  route_table_id = aws_route_table.my_private_route_table.id
}