module "vpc" {
  # source = "../Terraform-AWS-VPC"
  source = "git::https://github.com/viswanadhammanchem13/Terraform-AWS-VPC.git?ref=main"
  project = var.project
  environment = var.environment
  cidr_block = var.cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  database_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_cidrs = var.database_subnet_cidrs

   is_peering_required = true

   
}

# output "vpc_id" {
#      value = module.vpc.vpc_id
#  }