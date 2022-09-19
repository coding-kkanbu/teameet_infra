resource "aws_ecs_task_definition" "vue" {
  family = var.stage == "" ? "vue-task" : "vue-task-${var.stage}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  task_role_arn = var.task_role_arn
  
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "vuejs"
      image     = var.vuejs_image_url
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration : {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": aws_cloudwatch_log_group.vuejs.name,
          "awslogs-region": "ap-northeast-2",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
