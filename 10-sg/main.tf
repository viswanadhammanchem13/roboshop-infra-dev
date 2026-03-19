module "frontend" {
    # source = "../../terrafrom-aws-securitygroup"
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.description
    vpc-id = local.vpc_id
}