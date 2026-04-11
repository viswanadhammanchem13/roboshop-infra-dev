resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id = local.database_subnet_ids [0] # Assuming you want to use the first subnet from the list for the MongoDB instance.
  

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mongodb"
    }
  )
}

resource "terraform_data" "mongodb"{
  triggers_replace = [
    aws_instance.mongodb.id

  ]

    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }
    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = aws_instance.mongodb.private_ip
    }
    
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
        ]

    }
}


resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id = local.database_subnet_ids [0] # Assuming you want to use the first subnet from the list for the MySQL instance.
  iam_instance_profile = "EC2FetchSSMParams"
  

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mysql"
    }
  )
}

# resource "terraform_data" "mysql"{
#   triggers_replace = [
#   aws_instance.mysql.id
#   ]

#     provisioner "file" {
#         source      = "bootstrap.sh"
#         destination = "/tmp/bootstrap.sh"
#     }
#     connection {
#         type     = "ssh"
#         user     = "ec2-user"
#         password = "DevOps321"
#         host     = aws_instance.mongodb.private_ip
#     }
    
#     provisioner "remote-exec" {
#         inline = [
#         "chmod +x /tmp/bootstrap.sh",
#         "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
#         ]

#     }
# }

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
}


resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id = local.database_subnet_ids [0] # Assuming you want to use the first subnet from the list for the Redis instance.
  

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-redis"
    }
  )
}

resource "terraform_data" "redis"{
  triggers_replace = [
    aws_instance.redis.id
  ]

    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }
    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = aws_instance.redis.private_ip
    }
    
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
        ]

    }
}

resource "aws_instance" "rabbitmq" {
  iam_instance_profile = "EC2FetchSSMParams"
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  subnet_id = local.database_subnet_ids [0] # Assuming you want to use the first subnet from the list for the RabbitMQ instance.
  

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-rabbitmq"
    }
  )
}

resource "terraform_data" "rabbitmq"{
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]

    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }
    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = aws_instance.rabbitmq.private_ip
    }
    
    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
        ]

    }
}

# resource "aws_route53_record" "db_components" {
#   count= length(var.DB_Components) 
#   zone_id = var.zone_id
#   name    = "${var.DB_Components[count.index]}-dev.${var.zone_name}"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.var.DB_Components[count.index].private_ip]
#   allow_overwrite = true
# }

resource "aws_route53_record" "mongodb" {
  
  zone_id = var.zone_id
  name    = "mongodb.backend-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "mysql" {
  
  zone_id = var.zone_id
  name    = "mysql.backend-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis.backend-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq.backend-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}
