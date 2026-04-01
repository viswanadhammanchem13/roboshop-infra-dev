## Exporting the security group id to SSM parameter store for later use in other modules

resource "aws_ssm_parameter" "frontend_sg_id" {
    name  = "/${var.project}/${var.environment}/frontend_sg_id"
    type = "String"
    value = module.frontend.sg_id
}


## Exporting Bastion SG ID to SSM Parameter Store
resource "aws_ssm_parameter" "bastion_sg_id" {
    name  = "/${var.project}/${var.environment}/bastion_sg_id"
    type = "String"
    value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "backend-alb_sg_id"  {
    name  = "/${var.project}/${var.environment}/backend-alb_sg_id"
    type = "String"
    value = module.backend-alb.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id"  {
    name  = "/${var.project}/${var.environment}/vpn_sg_id"
    type = "String"
    value = module.vpn.sg_id
}