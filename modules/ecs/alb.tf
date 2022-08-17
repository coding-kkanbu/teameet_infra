resource "aws_alb" "teameet" {
  name               = var.stage == "" ? "teameet-alb" : "teameet-alb-${var.stage}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.alb_subnets # TODO: create subnets
  security_groups    = [aws_security_group.teameet.id]

  tags = {
    cluster        = "teameet"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_alb.teameet.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn # TODO: create certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.teameet.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.teameet.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
        protocol = "HTTPS"
        port = 443
        status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "teameet" {
  name        = var.stage == "" ? "teameet-tg" : "teameet-tg-${var.stage}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id # TODO: create VPC

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "404"
    timeout             = "3"
    path                = "/status" # TODO: replace it with actual path that return 200
    unhealthy_threshold = "5"
  }

  tags = {
    cluster        = "teameet"
  }
}
