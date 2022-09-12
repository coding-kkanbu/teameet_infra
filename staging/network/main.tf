terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13.0"
    }
  }
  backend "s3" {
    bucket = "teameet-terraform-remote-state"
    key    = "staging/network"
    region = "ap-northeast-2"
    profile = "teameet"
  }
}

provider "aws" {
  region = "ap-northeast-2"
  profile = "teameet"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "teameet-staging"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "staging"
  }
}