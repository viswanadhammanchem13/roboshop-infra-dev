resource "aws_ssm_parameter" "frontend_alb_acm"  {
    name  = "/${var.project}/${var.environment}/frontend-alb_acm"
    type = "String"
    value = aws_acm_certificate.manchem.id
}
