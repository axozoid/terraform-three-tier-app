# subnets for backend, one per AZ
resource "aws_subnet" "subnet_a_backend" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_a_backend["cidr"]}"
  tags = {
    Name = "${var.subnet_a_backend["name"]}"
  }
  availability_zone = "${var.subnet_a_backend["az"]}"
}
resource "aws_route_table_association" "rta_backend_a" {
  subnet_id      = aws_subnet.subnet_a_backend.id
  route_table_id = aws_route_table.rt_to_nat_gw.id
}

resource "aws_subnet" "subnet_b_backend" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_b_backend["cidr"]}"
  tags = {
    Name = "${var.subnet_b_backend["name"]}"
  }
  availability_zone = "${var.subnet_b_backend["az"]}"
}
resource "aws_route_table_association" "rta_backend_b" {
  subnet_id      = aws_subnet.subnet_b_backend.id
  route_table_id = aws_route_table.rt_to_nat_gw.id
}

# SG for the backend servers with allowed access from frontend servers and a bastion only
resource "aws_security_group" "sg_backend" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${var.sg_backend}"
  # allow access from the frontend SG
  ingress {
    from_port       = var.sgr_backend_ingress_port
    to_port         = var.sgr_backend_ingress_port
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg_frontend.id}"]
  }
  # allow access from the bastion SG
  ingress {
    from_port       = var.sgr_backend_ingress_port
    to_port         = var.sgr_backend_ingress_port
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg_bastion.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg_backend}"
  }
}

# launch configuration for backend instances
resource "aws_launch_configuration" "lc_backend" {
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "lc_backend_"
  image_id    = "${var.backend_ami_id}"
  # image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.lc_backend_instance_type}"
  key_name      = "${aws_key_pair.tf-key.key_name}"

  ebs_optimized = false
  root_block_device {
    volume_type = "${var.lc_backend_root_device_type}"
    volume_size = var.lc_backend_root_device_size
  }

  security_groups = ["${aws_security_group.sg_backend.id}"]

  # user_data = "${file("backend_userdata.sh")}"
}

# backend ASG
resource "aws_autoscaling_group" "asg_backend" {
  name                 = "${var.asg_backend}"
  launch_configuration = "${aws_launch_configuration.lc_backend.name}"
  min_size             = var.asg_backend_min
  max_size             = var.asg_backend_max
  health_check_type    = "${var.asg_backend_health_check_type}"
  vpc_zone_identifier  = ["${aws_subnet.subnet_a_backend.id}", "${aws_subnet.subnet_b_backend.id}"]
  load_balancers       = ["${aws_elb.lb_backend.name}"]
  lifecycle {
    create_before_destroy = true
  }
  depends_on                = [aws_elb.lb_backend]
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Name"
      value               = "${var.asg_backend_tag_name}"
      propagate_at_launch = true
    },
  ]

}

# backend ELB
resource "aws_elb" "lb_backend" {
  name                      = "${var.lb_backend}"
  cross_zone_load_balancing = true
  subnets                   = ["${aws_subnet.subnet_a_backend.id}", "${aws_subnet.subnet_b_backend.id}"]
  internal                  = true
  security_groups           = ["${aws_security_group.sg_backend.id}"]

  listener {
    lb_port           = var.sgr_backend_ingress_port
    lb_protocol       = "${var.lb_backend_protocol}"
    instance_port     = var.sgr_backend_ingress_port
    instance_protocol = "${var.lb_backend_protocol}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "${var.lb_backend_target_health_protocol}:${var.sgr_backend_ingress_port}/"
  }
}