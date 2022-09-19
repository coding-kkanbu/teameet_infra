resource "aws_ecs_service" "teameet" {
  name            = var.stage == "" ? "vuejs" : "vuejs-${var.stage}"
  cluster         = aws_ecs_cluster.teameet.id
  task_definition = aws_ecs_task_definition.vue.arn
  desired_count   = 1
  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_lb_target_group.teameet.arn
    container_name   = "vuejs"
    container_port   = 80
  }

  network_configuration {
    security_groups = [aws_security_group.teameet.id]
    assign_public_ip = true
    subnets = flatten(var.public_subnets) # TODO: create subnet
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 100
  }
  lifecycle {
    ignore_changes = [desired_count]
  }
}
