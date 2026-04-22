data "aws_ami" "openvpn" {
  owners      = [679593333241]
  most_recent = true
  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image-fe8020db*"]
  }

  filter {
    name   = "image-id"
    values = ["ami-04210df84866a6f22"]
  }
}



data "aws_ssm_parameter" "openvpn_sg_id" {
  name = "/${var.project}/${var.environment}/vpn_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"

}