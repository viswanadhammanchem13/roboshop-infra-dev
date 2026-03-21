module "frontend" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_description
    vpc-id = local.vpc_id
}


module "bastion" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_description
    vpc-id = local.vpc_id
}


## Bastion Host Accepting SSH from Laptop
resource "aws_security_group_rule" "bastion_from_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

  