variable "stage" {
  type = string
  default = ""
  description = "stage of deployment"
}

variable "memory_scaling_target_value" {
  type = number
  default = 80
}

variable "target_tracking_scaling_target_value" {
  type = number
  default = 1000
}

variable "cpu_scaling_target_value" {
  type = number
  default = 80
}

variable "certificate_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "teameet_image_url" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "alb_subnets" {
  type = list(string)
}