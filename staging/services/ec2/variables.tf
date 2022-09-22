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