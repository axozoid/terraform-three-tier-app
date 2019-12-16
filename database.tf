

resource "aws_security_group" "sg_db" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${var.sg_db}"
  ingress {
    from_port       = var.sgr_db_port
    to_port         = var.sgr_db_port
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg_frontend.id}","${aws_security_group.sg_bastion}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg_db}"
  }
}