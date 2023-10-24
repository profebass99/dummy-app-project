# create vpc
# terraform aws create vpc
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = var.cidr_block[0]
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment-prefix}-vpc"
  }
}

# create internet gateway and attach it to vpc
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "${var.environment-prefix}-IGW"
  }
}

# create public subnet az1
# terraform aws create subnet
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.cidr_block[1]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment-prefix}-public-subnet-AZ1"
  }
}

# create public subnet az2
# terraform aws create subnet
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.cidr_block[2]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment-prefix}-public-subnet-AZ2"
  }
}

# create route table and add public route
# terraform aws create route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.default_route
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.environment-prefix}-public-routetable-AZ1"
  }
}

# associate public subnet az1 to "public route table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public_subnet_2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# create private app subnet az1
# terraform aws create subnet
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.cidr_block[3]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment-prefix}-private-app-subnet-AZ1"
  }
}

# create private app subnet az2
# terraform aws create subnet
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.cidr_block[4]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment-prefix}-private-app-subnet-AZ2"
  }
}

# create private data subnet az1
# terraform aws create subnet
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.cidr_block[5]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment-prefix}-private-data-subnet-AZ1"
  }
}

# create private data subnet az2
# terraform aws create subnet
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.cidr_block[6]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment-prefix}-private-data-subnet-AZ2"
  }
}