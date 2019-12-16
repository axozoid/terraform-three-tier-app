### example values for DEV environment

# bastion host management port (sshd is listening on)
sg_bastion_port = 2022

# CIDR blocks from which the bastion on is available
sg_bastion_cidrs = ["0.0.0.0/0"]

# a port an ELB will be accepting connections on
sgr_lb_ingress_port = 80

# a port frontend servers are listening on
sgr_frontend_ingress_port = 8080


