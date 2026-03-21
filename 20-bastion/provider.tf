terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.26.0"
    }
  }

  backend "s3" {
    bucket = "84s-remotestate-manchem-dev"
    key    = "84s-remotestate-manchem-dev/20-bastion/terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "84s-remotestate-manchem"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}