provider "aws" {
    region = var.region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
        Name = var.vpc_name
    }
}

# Creates private subnets
resource "aws_subnet" "private" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = element(var.private_subnets, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "${var.vpc_name}_Private"
    }
}

# Creates public subnets
resource "aws_subnet" "public" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = element(var.public_subnets, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch  = true
    tags = {
        Name = "${var.vpc_name}_Public"
    } 
}

# Route table for the public subnet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.vpc_name}_Public_Route_Table"
    } 
}

# Route table for the private subnet
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.vpc_name}_Private_Route_Table"
    } 
}

# Routing rules for the public subnet
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet-gateway.id
}

# Creates an association between the public route table and the public subnet
resource "aws_route_table_association" "public" {
  
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Creates an association between the private route table and the private subnet
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

# Allow communication between the public subnets and the internet
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  tags = {
    Name = "${var.vpc_name}_Internet_Gateway"
  }
}