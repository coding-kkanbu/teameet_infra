variable "aws_region" {
  type = string
  default = "ap-northeast-2"
}

variable "aws_profile" {
  type = string
  default = "default"
}

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

# variable "certificate_arn" {
#   type = string
# }

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "vuejs_image_url" {
  type = string
}

variable "django_image_url" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "autoscaling_max_capacity" {
  type = number
  default = 2
}

variable "autoscaling_min_capacity" {
  type = number
  default = 1
}