# This file contains common networking bits

### create a VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.main_vpc_cidr}"
  tags       = var.main_vpc_tags
}

### create an IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.igw}"
  }
}

# create a route table with a route to the IGW
resource "aws_route_table" "rt_to_igw" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${var.rt_to_igw}"
  }
}

