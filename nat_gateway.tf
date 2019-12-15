# subnet for the NAT Gateway
# resource "aws_subnet" "subnet_nat_gateway" {
#   vpc_id     = "${aws_vpc.main.id}"
#   cidr_block = "${var.subnet_nat_gateway["cidr"]}"
#   tags = {
#     Name = "${var.subnet_nat_gateway["name"]}"
#   }
#   availability_zone = "${var.subnet_nat_gateway["az"]}"
# }

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.eip_nat_gw.id}"
  subnet_id     = "${aws_subnet.subnet_bastion.id}"

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_eip" "eip_nat_gw" {
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}