provider "aws" {
  version = "~> 2.0"
}

resource "aws_key_pair" "tf-key" {
  key_name   = "tf-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaq2lzh7GmB+6Rx3WbRsPXV6IsfHwvz/1d2iOKTvRp7wLTy/UEKwQxt53nprDwNEm5+mbtc3T4Ylw/iywgZwzBF4xOtoeA6ux9Ycg/reTS6jf1J8xnD0RGkL51JuYTwtsBzgA7HPVLqUrQaZMHoGCtybyOMxxACjYoP9++2GgEinXoVumlbXiwbc00iMNI0GDmhYBOPReig5JjzVFHeGUoGICmXGHdFrpQzrAgPg2V7iMEbquqJk6afkv3wnmsyBPXUBvPBd/aquXlGjqgjw3Q8QW2nwbP2sLBr6AjvYlxxhOtB72YpGUCQRw6+3jMdryDiUnaWecYDrbHYXZql/TaSrkeMRsLjehMc1paQsSeaCIg3WnDyiWrFQcBIt9f6vH2UcZ87JQVnW3MV1gwx0L+sbllwhgWQ1bloTEJtLf2fTx51C3L+S3Jvc1iiLiWAqhWfeqKKB8TjzeFULsw0CoUar04A7WF7x/2i5U5YDKJpAZRCA26BGxPBvHYf6XfLrNb3ca8iPss+83IinNa6HZxuOWVAy5jOjuooFPvuj+rY+ryGFPkHUaftkTICVuSYrRiLqcBb+y4ad1XMv4YmZmkcfcL/gr/eeeZNOaMrJ2Vvj7OA9LbBnAPEyf6G5YuWulvIblHhDax3/GPAw5e9bbI0Owbz/w4MQyzkXmJP+51vw=="
}

# grab the recent Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_eip" "lb_frontend" {
  vpc = true
}