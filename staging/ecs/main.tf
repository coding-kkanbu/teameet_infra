terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13.0"
    }
  }
  backend "s3" {
    bucket = "teameet-terraform-remote-state"
    key    = "staging/services/ecs"
    region = "ap-northeast-2"
    profile = "teameet"
  }
}

module "core-ecs" {
  source = "../../modules/ecs"

  aws_region = "ap-northeast-2"
  aws_profile = "teameet"

  stage = "staging"

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  public_subnets = data.terraform_remote_state.network.outputs.public_subnets
  
  # redis_endpoint = data.terraform_remote_state.data-stores.outputs.public_ip
  # redis_security_group_id = data.terraform_remote_state.data-stores.outputs.redis_security_group_id

  # db_host = data.terraform_remote_state.data-stores.outputs.public_ip
  # db_password = var.staging_db_password

  autoscaling_max_capacity = 2
  autoscaling_min_capacity = 1

  execution_role_arn = "arn:aws:iam::${var.aws_id}:role/ecsTaskExecutionRole"
  task_role_arn = "arn:aws:iam::${var.aws_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"

  vuejs_image_url = "${var.aws_id}.dkr.ecr.ap-northeast-2.amazonaws.com/vuejs"
  django_image_url = "${var.aws_id}.dkr.ecr.ap-northeast-2.amazonaws.com/django"
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

data "terraform_remote_state" "data-stores" {
  backend = "s3"

  config = {
      bucket = "teameet-terraform-remote-state"
      key    ="staging/data-stores/postgres_redis"
      region = "ap-northeast-2"
      profile = "teameet"
  }
}