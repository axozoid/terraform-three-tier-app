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

# SG for a frontend LB
resource "aws_security_group" "sg_frontend_lb" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${var.sg_frontend_lb}"
  ingress {
    from_port   = var.sgr_lb_ingress_port
    to_port     = var.sgr_lb_ingress_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg_frontend_lb}"
  }
}

# SG for the frontend servers with allowed access from the ELB's SG only
resource "aws_security_group" "sg_frontend" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${var.sg_frontend}"
  ingress {
    from_port       = var.sgr_frontend_ingress_port
    to_port         = var.sgr_frontend_ingress_port
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg_frontend_lb.id}"]
  }
  ingress {
    from_port       = var.sg_bastion_port
    to_port         = var.sg_bastion_port
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
    Name = "${var.sg_frontend}"
  }
}

# launch configuration for frontend instances
resource "aws_launch_configuration" "lc_frontend" {
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "lc_frontend_"
  image_id    = "${var.frontend_ami_id}"
  # image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.lc_frontend_instance_type}"
  key_name      = "${aws_key_pair.tf-key.key_name}"

  ebs_optimized = false
  root_block_device {
    volume_type = "${var.lc_frontend_root_device_type}"
    volume_size = var.lc_frontend_root_device_size
  }

  security_groups = ["${aws_security_group.sg_frontend.id}"]

  # "${file("frontend_userdata.sh")}"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              EOF
}

# ASG
resource "aws_autoscaling_group" "asg_frontend" {
  name                 = "${var.asg_frontend}"
  launch_configuration = "${aws_launch_configuration.lc_frontend.name}"
  min_size             = var.asg_frontend_min
  max_size             = var.asg_frontend_max
  health_check_type    = "${var.asg_frontend_health_check_type}"
  vpc_zone_identifier  = ["${aws_subnet.subnet_a_frontend.id}", "${aws_subnet.subnet_b_frontend.id}"]
  load_balancers       = ["${aws_elb.lb_frontend.name}"]
  lifecycle {
    create_before_destroy = true
  }
  depends_on                = [aws_elb.lb_frontend]
  wait_for_capacity_timeout = 0

  # tags = {
  #   Name = "${var.asg_frontend}"
  # }
}

# ELB
resource "aws_elb" "lb_frontend" {
  name = "${var.lb_frontend}"
  #   load_balancer_type               = "network"
  cross_zone_load_balancing = true
  subnets                   = ["${aws_subnet.subnet_a_frontend.id}", "${aws_subnet.subnet_b_frontend.id}"]

  security_groups = ["${aws_security_group.sg_frontend_lb.id}"]
  #   availability_zones = ["${data.aws_availability_zones.all.names}"]

  listener {
    lb_port           = var.sgr_lb_ingress_port
    lb_protocol       = "${var.lb_frontend_protocol}"
    instance_port     = var.sgr_frontend_ingress_port
    instance_protocol = "${var.lb_frontend_protocol}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "${var.lb_frontend_target_health_protocol}:${var.sgr_frontend_ingress_port}/"
  }
}

