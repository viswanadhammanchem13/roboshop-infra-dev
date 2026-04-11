resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("D:\\Devops\\Daws-84s\\Key_Authentication\\opnvpn.pub") #for mac and linux users use / and for windows users use \\ in the file path. Make sure to create this public key file in the specified location before running the Terraform code.
}

resource "aws_instance" "vpn-server" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.openvpn.value]
  subnet_id = local.public_subnet_ids
  key_name = aws_key_pair.openvpn.key_name #Make sure this key exported in AWS.
  #key_name = "Devops" ##If key is already exported in AWS, you can directly use the key name here instead of creating a new key pair resource.
  ##Headless Mode: In headless mode, the instance will not have a public IP address and will not be accessible from the internet. It will only be accessible from within the VPC. This is useful for instances that do not require internet access, such as backend servers or database servers.
  user_data = file("opnvpn.sh") #This is the script that will be executed when the instance is launched. It will install and configure OpenVPN on the instance. Make sure to create this script in the same directory as your Terraform files.
  

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-vpn"
    }
  )
}

resource "aws_route53_record" "vpn" {
  zone_id = var.zone_id
  name    = "vpn.backend-dev.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.vpn-server.public_ip]
  allow_overwrite = true
}