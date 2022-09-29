variable "aws_account" {
  type = string
}

variable "aws_profile" {
  type = string
  default = "teameet"
}

variable "postgres_db" {
  type = string
}

variable "postgres_password" {
  type = string
}

variable "postgres_user" {
  type = string
}

variable "postgres_url" {
  type = string
}

variable "redis_url" {
  type = string
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}