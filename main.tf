provider "aws" {
  version = "~> 2.0"
}

resource "aws_key_pair" "tf-key" {
  key_name   = "${var.ssh_key_name}"
  public_key = "${var.ssh_public_key}"
}

resource "aws_eip" "lb_frontend" {
  vpc = true
}