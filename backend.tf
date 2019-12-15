# subnets for backend, one per AZ
resource "aws_subnet" "subnet_a_backend" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_a_backend["cidr"]}"
  tags = {
    Name = "${var.subnet_a_backend["name"]}"
  }
  availability_zone = "${var.subnet_a_backend["az"]}"
}
resource "aws_subnet" "subnet_b_backend" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_b_backend["cidr"]}"
  tags = {
    Name = "${var.subnet_b_backend["name"]}"
  }
  availability_zone = "${var.subnet_b_backend["az"]}"
}

