data "aws_ami" "joindevops" {
    owners = [973714476881]
    most_recent = true
    filter {
        name =  "name"
        values = ["Redhat-9-DevOps-Practice"]
    }

    filter {
    name   = "image-id"
    values = ["ami-0220d79f3f480ecf5"]
  }
}

output "ami_id" {
    value = data.aws_ami.joindevops.id
    # value = data.aws_ami.joindevops.id
}

data "aws_ssm_parameter" "bastion_sg_id" {
    name  = "/${var.project}/${var.environment}/bastion_sg_id"
    
}

output "bastion_Sg_id" {
    value = data.aws_ssm_parameter.bastion_sg_id.value
    sensitive = true
  
}

data "aws_ssm_parameter" "public-subnet_ids" {
    name  = "/${var.project}/${var.environment}/public_subnet_ids"
    
}

output "public_subnet_ids" {
    value = data.aws_ssm_parameter.public-subnet_ids.value
    sensitive = true
}