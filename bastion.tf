# subnet for a bastion host
resource "aws_subnet" "subnet_bastion" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_bastion["cidr"]}"
  tags = {
    Name = "${var.subnet_bastion["name"]}"
  }
  availability_zone       = "${var.subnet_bastion["az"]}"
  map_public_ip_on_launch = true
}

# making this subnet public
resource "aws_route_table_association" "rta_bastion" {
  subnet_id      = aws_subnet.subnet_bastion.id
  route_table_id = aws_route_table.rt_to_igw.id
}