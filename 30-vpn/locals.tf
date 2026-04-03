locals{
    ami_id = data.aws_ami.openvpn.id
    openvpn = data.aws_ssm_parameter.openvpn_sg_id
    public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]

    common_tags = {
      Project = var.project
      Environment = var.environment
      Terraform = "true"
   }

}