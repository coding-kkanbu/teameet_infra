variable "aws_region" {
  type = string
  default = "ap-northeast-2"
}

variable "aws_profile" {
  type = string
  default = "teameet"
}

variable "postgres_password" {
  type = string
}

variable "postgres_user" {
  type = string
}

variable "postgres_db" {
  type = string
}