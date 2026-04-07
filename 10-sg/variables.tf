variable "project" {
    default= "roboshop"
  
}

variable "environment" {
    default= "dev"
  
}

variable "frontend_sg_name" {
    default= "frontend"
}

variable "frontend_description" {
  default = "Security group for frontend servers"
}

## Variables for Bastion-Security Group

variable "bastion_sg_name" {
    default= "bastion"
}

variable "bastion_description" {
  default = "Security group for bastion hosts"
}


variable "backend_alb_sg_name" {
    default= "backend-alb"
}

variable "backend_alb_description" {
  default = "Security group for backend ALB"
}


variable "vpn_sg_name" {
    default= "vpn-sg"
}

variable "vpn_description" {
  default = "Security group for VPN"
}

variable "mongodb_sg_name" {
    default= "mongodb-sg"
}

variable "mongodb_description" {
  default = "Security group for MongoDB"
}

variable "redis_sg_name" {
    default= "redis-sg"
}

variable "redis_description" {
  default = "Security group for Redis"
}

variable "mysql_sg_name" {
    default= "mysql-sg"
}

variable "mysql_description" {
  default = "Security group for MySQL"
}

variable "rabbitmq_sg_name" {
    default= "rabbitmq-sg"
}

variable "rabbitmq_description" {
  default = "Security group for RabbitMQ"
}

variable "redis_ports" {
  type = list(number)
default = [ 22,6379 ]
}

variable "mysql_ports" {
  type = list(number)
default = [ 22,3306 ]
}

variable "rabbitmq_ports" {
  type = list(number)
default = [ 22,5672 ]
}

variable "catalogue_sg_name" {
    default= "catalogue-sg"
}

variable "catalogue_description" {
  default = "Security group for Catalogue"
}


