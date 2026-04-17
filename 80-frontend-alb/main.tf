module "frontend_alb" {
  source = "terraform-aws-modules/alb/aws" #Automatically fetches the latest version of the module from the Terraform registry or GitHub repository.

  name    = "${var.project}-${var.environment}-frontend-alb"
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids
  create_security_group = false #We are setting this to false because we are creating the security group for backend ALB separately in the 10-sg module and we will pass the security group id to the ALB module.
  security_groups = [local.frontend_alb_sg_id] #This is a list.
  internal = false #This is set to true because we want to create an internal ALB that is not accessible from the internet. It will only be accessible from within the VPC.
  version = "10.4.0"
  enable_deletion_protection = false #This is set to false because we want to allow deletion of the ALB when we destroy the infrastructure. If this is set to true, we will have to manually disable deletion protection before destroying the infrastructure.
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-frontend-alb"
    }
  )
}

## ALB Listener
resource "aws_lb_listener" "frontend_alb-listener" {
  load_balancer_arn = module.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   =  local.frontend_alb_acm
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am form Frontend ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "frontend_alb-record" {
  zone_id = var.zone_id
  name    = "dev.${var.zone_name}"
  type    = "A"

  alias {
    name                   = module.frontend_alb.dns_name
    zone_id                = module.frontend_alb.zone_id #This is the hosted zone ID of the ALB. We can get this from the ALB module output.
    evaluate_target_health = true
  }
}