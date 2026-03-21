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
