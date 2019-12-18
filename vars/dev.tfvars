### example values for DEV environment

# bastion host management port (sshd is listening on)
sg_bastion_port = 2022

# CIDR blocks from which the bastion on is available
sg_bastion_cidrs = ["0.0.0.0/0"]

# a port an ELB will be accepting connections on
sgr_lb_ingress_port = 80

# a port frontend servers are listening on
sgr_frontend_ingress_port = 8080

# database port
sgr_db_port = 3306

# backend instance type
lc_backend_instance_type = "t2.micro"

# frontend instance type
lc_frontend_instance_type = "t2.micro"

# number of instances for frontend
asg_frontend_min = 2
asg_frontend_max = 4

# number of instances for backend
asg_backend_min = 1
asg_backend_max = 4

# database settings
db_name                = "my_dev_db"
db_username            = "admin"
db_password            = "a3dbd5e9c80a1a7195b4524749f9c3df"
db_deletion_protection = false
db_allocated_storage   = 30
db_skip_final_snapshot = false
