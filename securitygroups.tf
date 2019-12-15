
# SG for frontend LB
resource "aws_security_group" "sg_frontend_lb" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${var.sg_frontend}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "sgr_lb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_frontend_lb.id}"
}

# SG for the frontend servers with allowed access from the ELB onluy
resource "aws_security_group" "sg_frontend" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${var.sg_frontend}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "sgr_frontend_ingress" {
  type                     = "ingress"
  from_port                = var.sgr_frontend_ingress_port
  to_port                  = var.sgr_frontend_ingress_port
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.sg_frontend_lb.id}"
  security_group_id        = "${aws_security_group.sg_frontend.id}"
}


