##Creating Security Groups for Frontend
module "frontend" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_description
    vpc-id = local.vpc_id
}

##Creating Security Groups for Bastion
module "bastion" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_description
    vpc-id = local.vpc_id
}
 ##Creating Security Groups for Backend ALB
module "backend-alb" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.backend_alb_sg_name
    sg_description = var.backend_alb_description
    vpc-id = local.vpc_id
}

#Creating Security Group Rules for VPN to accept traffic from Frontend Servers.
module "vpn" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.vpn_sg_name
    sg_description = var.vpn_description
    vpc-id = local.vpc_id
}

#Creating Security Group Rules for VPN to accept traffic from Frontend Servers.
module "mongodb" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.mongodb_sg_name
    sg_description = var.mongodb_description
    vpc-id = local.vpc_id
}

module "redis" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.redis_sg_name
    sg_description = var.redis_description
    vpc-id = local.vpc_id
}

module "mysql" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.mysql_sg_name
    sg_description = var.mysql_description
    vpc-id = local.vpc_id
}

module "rabbitmq" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.rabbitmq_sg_name
    sg_description = var.rabbitmq_description
    vpc-id = local.vpc_id
}

module "catalogue" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.catalogue_sg_name
    sg_description = var.catalogue_description
    vpc-id = local.vpc_id
}
   

## Bastion Host Accepting SSH from Laptop
resource "aws_security_group_rule" "bastion_from_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #
  security_group_id = module.bastion.sg_id
}


# Creating Security Group Rules for Backend ALB to accept traffic from Bastion Host.
resource "aws_security_group_rule" "backend-alb_from_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.backend-alb.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

 ##VPN Ports 22,443,1194,943
# # Creating Security Group Rules for Backend ALB to accept traffic from Bastion Host.
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] #source security group allowing traffic from anywhere as we want to allow traffic from anywhere to VPN.
  security_group_id = module.vpn.sg_id #Destination security group is the VPN security group as we want to allow traffic to VPN.
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]#source security group allowing traffic from anywhere as we want to allow traffic from anywhere to VPN.
  security_group_id = module.vpn.sg_id #Destination security group is the VPN security group as we want to allow traffic to VPN.
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]#source security group allowing traffic from anywhere as we want to allow traffic from anywhere to VPN.
  security_group_id = module.vpn.sg_id #Destination security group is the VPN security group as we want to allow traffic to VPN.
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]#source security group allowing traffic from anywhere as we want to allow traffic from anywhere to VPN.
  security_group_id = module.vpn.sg_id #Destination security group is the VPN security group as we want to allow traffic to VPN.
}

# Creating Security Group Rules for Backend ALB to accept traffic from VPN.
resource "aws_security_group_rule" "backend_alb_from_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.backend-alb.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.mongodb.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.mongodb.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "mongodb_vpn_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.mongodb.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "redis_vpn" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.redis.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "mysql_vpn" {
  count = length(var.mysql_ports)
  type              = "ingress"
  from_port         = var.mysql_ports[count.index]
  to_port           = var.mysql_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.mysql.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "rabbitmq_vpn" {
  count = length(var.rabbitmq_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_ports[count.index]
  to_port           = var.rabbitmq_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.rabbitmq.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend-alb.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.catalogue.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.catalogue.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "catalogue_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.catalogue.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.catalogue.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.mongodb.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}