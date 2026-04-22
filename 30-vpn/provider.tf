terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }

  backend "s3" {
    bucket = "84s-remotestate-manchem-dev"
    # key    = "84s-remotestate-manchem/30-vpn-dev"
    key    = "30-vpn"
    region = "us-east-1"
    # dynamodb_table = "84s-remotestate-manchem"3w
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}