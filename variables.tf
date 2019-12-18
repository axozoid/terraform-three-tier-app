### VPC vars ###
variable "main_vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "main_vpc_tags" {
  type = "map"
  default = {
    Name    = "VPC_main"
    Project = "TestProject"
    Env     = "Dev"
  }
}

### subnet vars ###

# public
variable "subnet_bastion" {
  type = "map"
  default = {
    name = "subnet_bastion"
    cidr = "10.20.1.0/25"
    az   = "ap-southeast-2a"
  }
}

# private
variable "subnet_a_frontend" {
  type = "map"
  default = {
    name = "subnet_a_frontend"
    cidr = "10.20.2.0/25"
    az   = "ap-southeast-2a"
  }
}
variable "subnet_b_frontend" {
  type = "map"
  default = {
    name = "subnet_b_frontend"
    cidr = "10.20.2.128/25"
    az   = "ap-southeast-2b"
  }
}

variable "subnet_a_backend" {
  type = "map"
  default = {
    name = "subnet_a_backend"
    cidr = "10.20.3.0/25"
    az   = "ap-southeast-2a"
  }
}
variable "subnet_b_backend" {
  type = "map"
  default = {
    name = "subnet_b_backend"
    cidr = "10.20.3.128/25"
    az   = "ap-southeast-2b"
  }
}

variable "subnet_a_db" {
  type = "map"
  default = {
    name = "subnet_a_db"
    cidr = "10.20.4.0/25"
    az   = "ap-southeast-2a"
  }
}
variable "subnet_b_db" {
  type = "map"
  default = {
    name = "subnet_b_db"
    cidr = "10.20.4.128/25"
    az   = "ap-southeast-2b"
  }
}

# naming
variable "igw" {
  type    = string
  default = "igw_main"
}
variable "rt_to_nat_gw" {
  type    = string
  default = "rt_to_nat_gw"
}
variable "sg_frontend_lb" {
  type    = string
  default = "sg_frontend_lb"
}
variable "sg_frontend" {
  type    = string
  default = "sg_frontend"
}

variable "rt_to_igw" {
  type    = string
  default = "rt_to_igw"
}
variable "lb_frontend" {
  type    = string
  default = "lb-frontend"
}
variable "lb_backend" {
  type    = string
  default = "lb-backend"
}
variable "lb_frontend_protocol" {
  type    = string
  default = "http"
}
variable "lb_backend_protocol" {
  type    = string
  default = "http"
}
variable "lb_frontend_target_health_protocol" {
  type    = string
  default = "HTTP"
}
variable "lb_backend_target_health_protocol" {
  type    = string
  default = "HTTP"
}
variable "sg_bastion" {
  type    = string
  default = "sg_bastion"
}
variable "sgr_lb_ingress_port" {
  type    = number
  default = 80
}
variable "sgr_frontend_ingress_port" {
  type    = number
  default = 80
}
variable "sgr_backend_ingress_port" {
  type    = number
  default = 80
}
# launch config instance type for frontend
variable "lc_frontend_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "lc_backend_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "bastion_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "bastion_name" {
  type    = string
  default = "bastion_host"
}
variable "sg_db" {
  type    = string
  default = "sg_db"
}
variable "sgr_db_port" {
  type    = number
  default = 3306
}
variable "lc_frontend_root_device_type" {
  type    = string
  default = "gp2"
}
variable "lc_backend_root_device_type" {
  type    = string
  default = "gp2"
}
variable "frontend_ami_id" {
  type    = string
  default = "ami-04a0f7552cff370ba"
}
variable "bastion_ami_id" {
  type    = string
  default = "ami-04a0f7552cff370ba"
}
variable "backend_ami_id" {
  type    = string
  default = "ami-04a0f7552cff370ba"
}
variable "lc_frontend_root_device_size" {
  type    = number
  default = 20
}
variable "lc_backend_root_device_size" {
  type    = number
  default = 20
}

variable "asg_frontend" {
  type    = string
  default = "asg_frontend"
}
variable "asg_frontend_tag_name" {
  type    = string
  default = "frontend"
}
variable "asg_backend_tag_name" {
  type    = string
  default = "backend"
}
variable "asg_backend" {
  type    = string
  default = "asg_backend"
}
variable "asg_frontend_health_check_type" {
  type    = string
  default = "ELB"
}

variable "asg_backend_health_check_type" {
  type    = string
  default = "EC2"
}

variable "asg_frontend_min" {
  type    = number
  default = 2
}
variable "asg_frontend_max" {
  type    = number
  default = 6
}
variable "asg_backend_min" {
  type    = number
  default = 2
}
variable "asg_backend_max" {
  type    = number
  default = 6
}

# scale up
variable "asg_scale_up" {
  type    = string
  default = "asg_scale_up"
}
variable "asg_scale_up_adjustment_type" {
  type    = string
  default = "ChangeInCapacity"
}
variable "asg_scale_up_policy_type" {
  type    = string
  default = "SimpleScaling"
}
variable "asg_scale_up_scaling_adjustment" {
  type    = number
  default = 1
}
variable "asg_scale_up_cooldown" {
  type    = number
  default = 300
}
# scale down
variable "asg_scale_down" {
  type    = string
  default = "asg_scale_down"
}
variable "asg_scale_down_adjustment_type" {
  type    = string
  default = "ChangeInCapacity"
}
variable "asg_scale_down_policy_type" {
  type    = string
  default = "SimpleScaling"
}
variable "asg_scale_down_scaling_adjustment" {
  type    = number
  default = -1
}
variable "asg_scale_down_cooldown" {
  type    = number
  default = 300
}

variable "cw_alarm_cpu_high" {
  type    = string
  default = "cw_alarm_cpu_high"
}
variable "cw_cpu_high_max_threshold" {
  type    = number
  default = 80
}
variable "cw_alarm_cpu_low" {
  type    = string
  default = "cw_alarm_cpu_low"
}
variable "cw_cpu_low_min_threshold" {
  type    = number
  default = 20
}

variable "cw_statistic_period" {
  type    = number
  default = 300
}
variable "cw_number_of_periods" {
  type    = number
  default = 2
}
variable "cw_statistic_type" {
  type    = string
  default = "Average"
}
variable "sg_bastion_port" {
  type    = number
  default = 22
}
variable "sg_bastion_cidrs" {
  type    = list
  default = ["0.0.0.0/0", "1.2.3.4/32"]
}

variable "sg_backend" {
  type    = string
  default = "sg_backend"
}

variable "ssh_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaq2lzh7GmB+6Rx3WbRsPXV6IsfHwvz/1d2iOKTvRp7wLTy/UEKwQxt53nprDwNEm5+mbtc3T4Ylw/iywgZwzBF4xOtoeA6ux9Ycg/reTS6jf1J8xnD0RGkL51JuYTwtsBzgA7HPVLqUrQaZMHoGCtybyOMxxACjYoP9++2GgEinXoVumlbXiwbc00iMNI0GDmhYBOPReig5JjzVFHeGUoGICmXGHdFrpQzrAgPg2V7iMEbquqJk6afkv3wnmsyBPXUBvPBd/aquXlGjqgjw3Q8QW2nwbP2sLBr6AjvYlxxhOtB72YpGUCQRw6+3jMdryDiUnaWecYDrbHYXZql/TaSrkeMRsLjehMc1paQsSeaCIg3WnDyiWrFQcBIt9f6vH2UcZ87JQVnW3MV1gwx0L+sbllwhgWQ1bloTEJtLf2fTx51C3L+S3Jvc1iiLiWAqhWfeqKKB8TjzeFULsw0CoUar04A7WF7x/2i5U5YDKJpAZRCA26BGxPBvHYf6XfLrNb3ca8iPss+83IinNa6HZxuOWVAy5jOjuooFPvuj+rY+ryGFPkHUaftkTICVuSYrRiLqcBb+y4ad1XMv4YmZmkcfcL/gr/eeeZNOaMrJ2Vvj7OA9LbBnAPEyf6G5YuWulvIblHhDax3/GPAw5e9bbI0Owbz/w4MQyzkXmJP+51vw=="
}
variable "ssh_key_name" {
  type    = string
  default = "tf-key"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}
variable "db_backup_retention_period" {
  type    = number
  default = 14
}
variable "db_storage_type" {
  type    = string
  default = "gp2"
}
variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "5.7"
}
variable "db_instance_class" {
  type    = string
  default = "db.t2.micro"
}
variable "db_name" {
  type    = string
  default = "my_app_db"
}
variable "db_identifier_prefix" {
  type    = string
  default = "db-main-"
}
variable "db_subnets" {
  type    = string
  default = "db_subnets"
}
variable "db_apply_immediately" {
  type    = bool
  default = false
}
variable "db_deletion_protection" {
  type    = bool
  default = false
}
variable "db_publicly_accessible" {
  type    = bool
  default = false
}
variable "db_multi_az" {
  type    = bool
  default = false
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}

