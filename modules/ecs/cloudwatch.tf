resource "aws_cloudwatch_log_group" "teameet" {
  name = var.stage == "" ? "teameet-log" : "teameet-log-${var.stage}"
}
