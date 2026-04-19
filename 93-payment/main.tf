resource "aws_lb_target_group" "payment" {
  name     = "${var.project}-${var.environment}-payment" #roboshop-dev-payment
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = 8080
    matcher             = "200-299"
    interval            = 5
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_instance" "payment" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.payment_sg_id]
  subnet_id = local.private_subnet_ids # Assuming you want to use the first subnet from the list for the MongoDB instance.
  # iam_instance_profile = "EC2FetchSSMParams"
  

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-payment"
    }
  )
}

resource "terraform_data" "payment"{
  triggers_replace = [ ##This trigger will cause the data source to be recreated whenever the payment instance is replaced.
    aws_instance.payment.id

  ]

    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }
    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = aws_instance.payment.private_ip
    }
    
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh payment ${var.environment}"
        ]

    }
}

resource "aws_ec2_instance_state" "payment" {
  instance_id = aws_instance.payment.id
  state       = "stopped"
  depends_on = [terraform_data.payment]
}

resource "aws_ami_from_instance" "payment" {
  name               = "${var.project}-${var.environment}-payment"
  source_instance_id = aws_instance.payment.id
  depends_on = [aws_ec2_instance_state.payment]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-payment"
    }
  )
}
##If you want to start the instance after creating the AMI, you can use the following terraform_data resource to execute the AWS CLI command to start the instance. However, it is important to note that starting the instance after creating the AMI may not be necessary, as the instance will be stopped and an AMI will be created from it. You can choose to keep the instance stopped or terminate it after creating the AMI, depending on your requirements and cost considerations. If you decide to keep the instance stopped, you can remove this terraform_data resource and manage the instance state manually using AWS CLI or AWS Console as needed.
# resource "terraform_data" "payment_start_instance"{
#   triggers_replace = [
#     aws_instance.payment.id
#   ]
#   ##Makesure aws configuration is done in the system where you are running terraform apply, otherwise this command will fail. You can use AWS CLI or AWS Console to check the status of the instance and AMI creation.
#   ## Make sure to terminate the instance after creating the AMI, otherwise you will have an extra running instance that is not needed.
#   provisioner "local-exec" {
#     command = "aws ec2 start-instances --instance-ids ${aws_instance.payment.id}"
#   }

#   depends_on = [aws_ami_from_instance.payment]
# }

resource "terraform_data" "payment_delete_instance"{
  triggers_replace = [
    aws_instance.payment.id
  ]
  ##Makesure aws configuration is done in the system where you are running terraform apply, otherwise this command will fail. You can use AWS CLI or AWS Console to check the status of the instance and AMI creation.
  ## Make sure to terminate the instance after creating the AMI, otherwise you will have an extra running instance that is not needed.
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.payment.id}"
  }
  depends_on = [aws_ami_from_instance.payment]
    
}

resource "aws_launch_template" "payment" {
  name = "${var.project}-${var.environment}-payment"
  update_default_version = true ##Each time you run terraform apply, it will create a new version of the launch template with the updated AMI ID and it makes as default version, so that when you launch an instance using this launch template, it will use the latest version with the updated AMI ID. This ensures that any new instances launched using this launch template will have the latest AMI with the necessary configurations for the payment service.

  image_id = aws_ami_from_instance.payment.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.payment_sg_id]

 ## Instance tags are important for cost allocation and resource management. By tagging the instances associated with the payment service, you can easily identify and track the costs associated with those instances in your AWS billing reports. Additionally, if you need to perform any maintenance or troubleshooting on the instances, having them tagged with relevant information (such as project name, environment, etc.) can help you quickly identify which instances are associated with the payment service and take appropriate actions. 

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-payment"
      }
    )
    }
##Volume tags are important for cost allocation and resource management. By tagging the volumes associated with the payment instances, you can easily identify and track the costs associated with those volumes in your AWS billing reports. Additionally, if you need to perform any maintenance or troubleshooting on the volumes, having them tagged with relevant information (such as project name, environment, etc.) can help you quickly identify which volumes are associated with the payment instances and take appropriate actions.
    tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-payment"
      }
    )
    }
## Launch Template tags are applied to both the instance and the volume, so we need to specify the tags for both resource types. This ensures that when an instance is launched using this launch template, both the instance and its associated volume will have the correct tags for identification and management purposes.
    tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-payment"
      }
    )
  }


  resource "aws_autoscaling_group" "payment" {
    name   = "${var.project}-${var.environment}-payment" #roboshop-dev-payment
    target_group_arns = [aws_lb_target_group.payment.arn]
    vpc_zone_identifier = local.private_subnet_id
    health_check_grace_period = 90
    health_check_type         = "ELB"
    desired_capacity   = 1
    max_size           = 10
    min_size           = 1

  launch_template {
    id      = aws_launch_template.payment.id
    version = aws_launch_template.payment.latest_version
  }

  dynamic "tag" {
    for_each =  merge (
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-payment"
      } 
    )
    content {
      key                 = tag.key
     value               = tag.value
     propagate_at_launch = true
       
    }
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 ##This means that during the instance refresh process, at least 50% of the instances in the Auto Scaling group must be healthy and available to serve traffic. This helps ensure that there is sufficient capacity to handle incoming requests while instances are being replaced or updated.
    }
    triggers = ["launch_template"]
  }

  timeouts{
        delete = "15m"
 }
 }  


 resource "aws_autoscaling_policy" "payment" {
  name                   = "${var.project}-${var.environment}-payment"
  autoscaling_group_name = aws_autoscaling_group.payment.name
   policy_type            = "TargetTrackingScaling"
  #  cooldown               = 120 ##Cooldown period is the amount of time, in seconds, after a scaling activity completes before any further scaling activities can start. This helps prevent rapid scaling actions that could lead to instability in your application. In this case, a cooldown period of 120 seconds means that after a scaling activity (either scale out or scale in) is completed, the Auto Scaling group will wait for 120 seconds before it can initiate another scaling activity. This allows the system to stabilize and ensures that the scaling actions are not triggered too frequently, which could lead to unnecessary costs and performance issues.
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "payment" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.payment.arn
  }

  condition {
    host_header {
      values = ["payment.backend-${var.environment}.${var.zone_name}"]
    }
  }
}

 