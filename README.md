## Example of a `3 tier application` deployed in AWS using Terraform

This example code will deploy the following:

### Bastion host
* Publicly available;
* SSH port and IP filtering can be configured via variables;
* AMI may be supplied via variables;

### Frontend Load Balancer
* Publicly available, serves as an entry point for the service (application);
* Cross zone load balancing;

### Frontend servers (aka Tier 1)
* Accessible only from the Frontend Load Balancer or the Bastion host;
* Deployed across 2 AZs;
* Created as an ASG with configurable parameters (min, max, health checks, etc.);

### Backend Internal Load Balancer
* Deployed in a private subnet and only accessible from the Frontend servers;

### Backend servers (aka Tier 2)
* Accessible only from the Frontend servers or the Bastion host;
* Deployed across 2 AZs;
* Created as an ASG with configurable parameters (min, max, health checks, etc.);

### Database (aka Tier 3)
* Implemented as an RDS instance deployed with `multi_az` support;
* Accesible only from Backend servers or the Bastion host;

## How to deploy
1. Make sure you've got your AWS credentials configured;
2. To deploy with default values, run the following:
```
terraform apply
```
or supply your values like this:
```
terraform apply -var-file vars/dev.tfvars
```

(!) It's not recommended to store any credentials in your config files, that's why
when you start deployement, you will be asked to provide values for `db_password` and `db_username`:
```
var.db_password
  Enter a value: 

var.db_username
  Enter a value: 
```
## Outputs
Once the stack is deployed, Terraform will print out some useful connection info, for e.g.:
```
Outputs:

Bastion_Public_IP = [
  "123.45.56.78",
]
Bastion_SSH_Port = [
  22,
]
Frontend_Load_Balancer_DNS = [
  "lb-frontend-93756961.ap-southeast-2.elb.amazonaws.com",
]
```

If we go and hit the ELB's DNS name, we may see that there is a web server listening:
```
curl -s -I lb-frontend-93756961.ap-southeast-2.elb.amazonaws.com
HTTP/1.1 200 OK
Accept-Ranges: bytes
Content-Length: 612
Content-Type: text/html
Date: Wed, 18 Dec 2019 06:05:58 GMT
ETag: "5df9bc44-264"
Last-Modified: Wed, 18 Dec 2019 05:42:28 GMT
Server: nginx/1.14.0 (Ubuntu)
Connection: Close
```

## TODO
* Convert this to a module;
* Place bastion host into ASG;
* Improve code base;