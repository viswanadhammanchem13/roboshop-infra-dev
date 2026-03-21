## Exporting the vpc id to SSM parameter store for later use in other modules and type is String because we are passing single value of vpc id

resource "aws_ssm_parameter" "vpc_id" {
    name  = "/${var.project}/${var.environment}/vpc_id"
    type = "String"
    value = module.vpc.vpc_id
}

## Exporting the public subnet ids to SSM parameter store for later use in other modules and type is StringList because we are passing list of subnet ids 

resource "aws_ssm_parameter" "public_subnet_ids" {
    name  = "/${var.project}/${var.environment}/public_subnet_ids"
    type = "StringList"
    value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
    name  = "/${var.project}/${var.environment}/private_subnet_ids"
    type = "StringList"
    value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
    name  = "/${var.project}/${var.environment}/database_subnet_ids"
    type = "StringList"
    value = join(",", module.vpc.database_subnet_ids)
}