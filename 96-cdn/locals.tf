locals {
    acm_certificate_arn = data.aws_ssm_parameter.frontend_alb_acm.value 
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
}