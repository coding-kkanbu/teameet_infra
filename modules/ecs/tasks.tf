resource "aws_ecs_task_definition" "thumb_core" {
  family = var.task_definition_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 4096
  memory                   = 8192
  task_role_arn = var.task_role_arn
  
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "teameet"
      image     = var.teameet_image_url
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      logConfiguration : {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": aws_cloudwatch_log_group.teameet.name,
          "awslogs-region": "ap-northeast-2",
          "awslogs-stream-prefix": "ecs"
        }
      }
      environment: [
        {
            "name": "PORT",
            "value": "8000"
        },
    ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
