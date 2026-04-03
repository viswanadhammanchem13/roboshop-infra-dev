module "backend-alb" {
  source = "terraform-aws-modules/alb/aws" #Automatically fetches the latest version of the module from the Terraform registry or GitHub repository.

  name    = "${var.project}-${var.environment}-backend-alb"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids
  create_security_group = false #We are setting this to false because we are creating the security group for backend ALB separately in the 10-sg module and we will pass the security group id to the ALB module.
  security_groups = [local.backend_alb_sg_id] #This is a list.
  internal = true #This is set to true because we want to create an internal ALB that is not accessible from the internet. It will only be accessible from within the VPC.
  version = "10.4.0"
  enable_deletion_protection = false #This is set to false because we want to allow deletion of the ALB when we destroy the infrastructure. If this is set to true, we will have to manually disable deletion protection before destroying the infrastructure.
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-backend-alb"
    }
  )
}

## ALB Listener
resource "aws_lb_listener" "backend_alb-listener" {
  load_balancer_arn = module.backend-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am form Backend ALB</h1>"
      status_code  = "200"
    }
  }
}