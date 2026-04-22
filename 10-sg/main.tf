##Creating Security Groups for Roboshop Application.

#Creating Security Group for Frontend.
module "frontend" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_description
    vpc-id = local.vpc_id
}

#Creating Security Group for Bastion.
module "bastion" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_description
    vpc-id = local.vpc_id
}



 #Creating Security Group for Backend ALB.
module "backend-alb" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.backend_alb_sg_name
    sg_description = var.backend_alb_description
    vpc-id = local.vpc_id
}

#Creating Security Group for VPN.
module "vpn" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.vpn_sg_name
    sg_description = var.vpn_description
    vpc-id = local.vpc_id
}



#Creating Security Group for MongoDB.
module "mongodb" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.mongodb_sg_name
    sg_description = var.mongodb_description
    vpc-id = local.vpc_id
}

#Creating Security Group for Redis.
module "redis" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.redis_sg_name
    sg_description = var.redis_description
    vpc-id = local.vpc_id
}


#Creating Security Group for MySQL.
module "mysql" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.mysql_sg_name
    sg_description = var.mysql_description
    vpc-id = local.vpc_id
}

#Creating Security Group for RabbitMQ.
module "rabbitmq" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.rabbitmq_sg_name
    sg_description = var.rabbitmq_description
    vpc-id = local.vpc_id
}

#Creating Security Group for Catalogue.
module "catalogue" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.catalogue_sg_name
    sg_description = var.catalogue_description
    vpc-id = local.vpc_id
}

module "user" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "user"
    sg_description = "for user"
    vpc_id = local.vpc_id
}

module "cart" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "cart"
    sg_description = "for cart"
    vpc_id = local.vpc_id
}

module "shipping" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "shipping"
    sg_description = "for shipping"
    vpc_id = local.vpc_id
}

module "payment" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "payment"
    sg_description = "for payment"
    vpc_id = local.vpc_id
}

module "frontend_alb" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "frontend_alb"
    sg_description = "for frontend alb"
    vpc_id = local.vpc_id
}



##Bation Host
resource "aws_security_group_rule" "bastion_from_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Source
  security_group_id = module.bastion.sg_id
}

# BackendALB
resource "aws_security_group_rule" "backend-alb_from_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id 
  security_group_id = module.backend-alb.sg_id 
}

resource "aws_security_group_rule" "backend_alb_from_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id 
  security_group_id = module.backend-alb.sg_id 
}

resource "aws_security_group_rule" "backend_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend-alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.backend-alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.backend-alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.backend-alb.sg_id
}

##Frontend
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id = module.frontend.sg_id
}

#Frontend ALB
resource "aws_security_group_rule" "frontend_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.backend-alb.sg_id
}

resource "aws_security_group_rule" "frontend_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

##VPN
##VPN Ports 22,443,1194,943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] 
  security_group_id = module.vpn.sg_id 
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id 
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id 
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id 
}


##MongoDB
resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id 
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id 
  security_group_id = module.mongodb.sg_id 
}

resource "aws_security_group_rule" "mongodb_vpn_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id 
  security_group_id = module.mongodb.sg_id 
}

resource "aws_security_group_rule" "mongodb_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id 
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id 
  security_group_id = module.mongodb.sg_id 
} 


resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id 
  security_group_id = module.mongodb.sg_id 
} 

##Redis
resource "aws_security_group_rule" "redis_vpn" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.redis.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}


resource "aws_security_group_rule" "redis_bastion" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.redis.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}


resource "aws_security_group_rule" "redis_user" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.redis.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "redis_cart" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.redis.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}
##MYSQL
resource "aws_security_group_rule" "mysql_vpn" {
  count = length(var.mysql_ports)
  type              = "ingress"
  from_port         = var.mysql_ports[count.index]
  to_port           = var.mysql_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.mysql.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "mysql_bastion" {
  count = length(var.mysql_ports)
  type              = "ingress"
  from_port         = var.mysql_ports[count.index]
  to_port           = var.mysql_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.mysql.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "mysql_shipping" {
  count = length(var.mysql_ports)
  type              = "ingress"
  from_port         = var.mysql_ports[count.index]
  to_port           = var.mysql_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.mysql.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}


##RabbitMQ
resource "aws_security_group_rule" "rabbitmq_vpn" {
  count = length(var.rabbitmq_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_ports[count.index]
  to_port           = var.rabbitmq_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.rabbitmq.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "rabbitmq_bastion" {
  count = length(var.rabbitmq_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_ports[count.index]
  to_port           = var.rabbitmq_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.rabbitmq.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  count = length(var.rabbitmq_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_ports[count.index]
  to_port           = var.rabbitmq_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id #Source security group is the RabbitMQ security group as we want to allow traffic from RabbitMQ to backend ALB.
  security_group_id = module.rabbitmq.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

##Catalogue

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

##User
resource "aws_security_group_rule" "user_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend-alb.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.user.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "user_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.user.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "user_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.user.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "user_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.user.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

##Cart

resource "aws_security_group_rule" "cart_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend-alb.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.cart.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "cart_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.cart.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "cart_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.cart.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "cart_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.cart.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

##Shipping
resource "aws_security_group_rule" "shipping_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend-alb.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.shipping.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "shipping_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.shipping.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "shipping_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.shipping.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "shipping_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.shipping.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

##Payment
resource "aws_security_group_rule" "payment_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend-alb.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.payment.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "payment_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.payment.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "payment_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id #Source security group is the bastion host security group as we want to allow traffic from bastion host to backend ALB.
  security_group_id = module.payment.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}

resource "aws_security_group_rule" "payment_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id #Source security group is the VPN security group as we want to allow traffic from VPN to backend ALB.
  security_group_id = module.payment.sg_id #Destination security group is the backend ALB security group as we want to allow traffic to backend ALB.
}



