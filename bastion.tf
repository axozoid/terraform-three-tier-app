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

# SG for a bastion host
resource "aws_security_group" "sg_bastion" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${var.sg_bastion}"
  ingress {
    from_port   = var.sg_bastion_port
    to_port     = var.sg_bastion_port
    protocol    = "tcp"
    cidr_blocks = var.sg_bastion_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg_bastion}"
  }
}

# TODO: replace with ASG
resource "aws_instance" "bastion" {
  ami                         = "${var.bastion_ami_id}"
  key_name                    = "${aws_key_pair.tf-key.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.sg_bastion.id}"]
  instance_type               = "${var.bastion_instance_type}"
  subnet_id                   = "${aws_subnet.subnet_bastion.id}"
  associate_public_ip_address = true
  tags = {
    Name = "${var.bastion_name}"
  }
}