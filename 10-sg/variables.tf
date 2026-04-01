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