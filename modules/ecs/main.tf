provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

resource "aws_ecs_cluster" "teameet" {
  name = var.stage == "" ? "teameet-cluster" : "teameet-cluster-${var.stage}"
}

resource "aws_ecs_cluster_capacity_providers" "teameet" {
  cluster_name = aws_ecs_cluster.teameet.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_appautoscaling_target" "teameet" {
  max_capacity = var.autoscaling_max_capacity
  min_capacity = var.autoscaling_min_capacity
  resource_id = "service/${aws_ecs_cluster.teameet.name}/${aws_ecs_service.teameet.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "teameet_memory_scale" {
  name               = "${aws_ecs_cluster.teameet.name}-memory-scale"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.teameet.resource_id
  scalable_dimension = aws_appautoscaling_target.teameet.scalable_dimension
  service_namespace  = aws_appautoscaling_target.teameet.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.memory_scaling_target_value
  }
}

resource "aws_appautoscaling_policy" "teameet_request_count_scale" {
  name               = "${aws_ecs_cluster.teameet.name}-request-count-scale"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.teameet.resource_id
  scalable_dimension = aws_appautoscaling_target.teameet.scalable_dimension
  service_namespace  = aws_appautoscaling_target.teameet.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "${aws_alb.teameet.arn_suffix}/${aws_lb_target_group.teameet.arn_suffix}"
    }

    target_value       = var.target_tracking_scaling_target_value
  }
}

resource "aws_appautoscaling_policy" "teameet_request_cpu_scale" {
  name = "teameet-request-cpu-scale"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.teameet.resource_id
  scalable_dimension = aws_appautoscaling_target.teameet.scalable_dimension
  service_namespace = aws_appautoscaling_target.teameet.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.cpu_scaling_target_value
  }
}

resource "aws_security_group" "teameet" {
  vpc_id = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "teameet-sg"
  }
}
