output "Bastion_Public_IP" {
  description = "Bastion host Public IP address."
  value       = ["${aws_instance.bastion.public_ip}"]
}
output "Bastion_SSH_Port" {
  description = "Bastion host SSH port number."
  value       = ["${var.sg_bastion_port}"]
}
output "Frontend_Load_Balancer_DNS" {
  description = "Bastion host SSH port number."
  value       = ["${aws_elb.lb_frontend.dns_name}"]
}