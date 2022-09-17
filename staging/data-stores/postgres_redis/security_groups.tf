resource "aws_security_group" "ingress_postgres" {
  name = "ingress_postgres"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
  }

  tags = {
    Name = "ingress_postgres"
  }
}

resource "aws_security_group" "ingress_redis" {
  name = "ingress_redis"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
      from_port = 6379
      to_port = 6379
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
  }

  tags = {
    Name = "ingress_redis"
  }
}

resource "aws_security_group" "ssh" {
  name = "ssh"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
  }

  tags = {
    Name = "ssh"
  }
}

resource "aws_security_group" "egress_all" {
  name = "egress_all"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
  }

  tags = {
    Name = "egress_all"
  }
}