# subnets for frontend, one per AZ
resource "aws_subnet" "subnet_a_frontend" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_a_frontend["cidr"]}"
  tags = {
    Name = "${var.subnet_a_frontend["name"]}"
  }
  availability_zone = "${var.subnet_a_frontend["az"]}"
}
resource "aws_subnet" "subnet_b_frontend" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_b_frontend["cidr"]}"
  tags = {
    Name = "${var.subnet_b_frontend["name"]}"
  }
  availability_zone = "${var.subnet_b_frontend["az"]}"
}