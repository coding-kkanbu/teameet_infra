resource "aws_cloudwatch_log_group" "vuejs" {
  name = var.stage == "" ? "vuejs-log" : "vuejs-log-${var.stage}"
}

resource "aws_cloudwatch_log_group" "django" {
  name = var.stage == "" ? "django-log" : "django-log-${var.stage}"
}
