terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13.0"
    }
  }
  backend "s3" {
    bucket = "teameet-terraform-remote-state"
    key    = "staging/services/ec2"
    region = "ap-northeast-2"
    profile = "teameet"
  }
}

provider "aws" {
  region  = local.aws_region
  profile = var.aws_profile
}

resource "aws_instance" "core" {
  ami           = local.ubuntu_ami
  instance_type = local.instance_type
  associate_public_ip_address = true
  subnet_id = data.terraform_remote_state.network.outputs.public_subnets[0]

  vpc_security_group_ids = [ 
    aws_security_group.app.id
  ]

  user_data = templatefile("setup.sh.tftpl", {
      postgres_password = var.postgres_password,
      postgres_user = var.postgres_user,
      postgres_db = var.postgres_db,
      postgres_url = var.postgres_url,
      aws_account = var.aws_account,
      AWS_ACCESS_KEY_ID = var.AWS_ACCESS_KEY_ID,
      AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY,
      AWS_REGION = local.aws_region,
    })

  tags = {
    Name = "app"
  }
}

locals {
  ubuntu_ami = "ami-058165de3b7202099" # x86
  aws_region = "ap-northeast-2"
  instance_type = "t2.micro"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
      bucket = "teameet-terraform-remote-state"
      key = "staging/network"
      region = "ap-northeast-2"
      profile = "teameet"
  }
}
