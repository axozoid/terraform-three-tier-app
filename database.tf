
resource "aws_security_group" "sg_db" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${var.sg_db}"
  # allow access from a bastion or backend servers only
  ingress {
    from_port = var.sgr_db_port
    to_port   = var.sgr_db_port
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.sg_bastion.id}",
      "${aws_security_group.sg_backend.id}"
    ]
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

# RDS subnets
resource "aws_subnet" "subnet_a_db" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_a_db["cidr"]}"
  tags = {
    Name = "${var.subnet_a_db["name"]}"
  }
  availability_zone = "${var.subnet_a_db["az"]}"
}
resource "aws_subnet" "subnet_b_db" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_b_db["cidr"]}"
  tags = {
    Name = "${var.subnet_b_db["name"]}"
  }
  availability_zone = "${var.subnet_b_db["az"]}"
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.db_subnets}"
  subnet_ids = ["${aws_subnet.subnet_a_db.id}", "${aws_subnet.subnet_b_db.id}"]

  tags = {
    Name = "${var.db_subnets}"
  }
}

# RDS instance
resource "aws_db_instance" "main_rds" {
  allocated_storage       = var.db_allocated_storage
  storage_type            = "${var.db_storage_type}"
  engine                  = "${var.db_engine}"
  engine_version          = "${var.db_engine_version}"
  instance_class          = "${var.db_instance_class}"
  apply_immediately       = var.db_apply_immediately
  backup_retention_period = var.db_backup_retention_period
  deletion_protection     = var.db_deletion_protection
  identifier_prefix       = "${var.db_identifier_prefix}"
  multi_az                = var.db_multi_az
  vpc_security_group_ids  = ["${aws_security_group.sg_db.id}"]
  publicly_accessible     = var.db_publicly_accessible
  db_subnet_group_name    = aws_db_subnet_group.db_subnets.id
  skip_final_snapshot     = var.db_skip_final_snapshot
  # database with the name below will be created once the instance is provisioned
  name     = "${var.db_name}"
  username = "${var.db_username}"
  password = "${var.db_password}"
}