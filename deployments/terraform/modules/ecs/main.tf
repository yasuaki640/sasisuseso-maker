
import {
  id = "sasisuseso-maker"
  to = aws_ecs_cluster.main
}
resource "aws_ecs_cluster" "main" {
  name = "sasisuseso-maker"
  service_connect_defaults {
    namespace = "arn:aws:servicediscovery:ap-northeast-1:839063654285:namespace/ns-4r44zsf4nnjeqtjx"
  }
}

import {
  id = "sasisuseso-maker/app"
  to = aws_ecs_service.main
}
resource "aws_ecs_service" "main" {
  availability_zone_rebalancing = "ENABLED"
  name                               = "app"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  scheduling_strategy                = "REPLICA"
  desired_count                      = 0
  iam_role                           = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  platform_version                   = "LATEST"

  network_configuration {
    assign_public_ip = true
    security_groups  = ["sg-0b520646a074cfe8c"]
    subnets          = ["subnet-54f87b1c", "subnet-b3ae2498", "subnet-f98c71a3"]
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }
}

import {
  id = "arn:aws:ecs:ap-northeast-1:839063654285:task-definition/sasisuseso-maker-taskdef:1"
  to = aws_ecs_task_definition.main
}
resource "aws_ecs_task_definition" "main" {
  family                   = "sasisuseso-maker-taskdef"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = "arn:aws:iam::839063654285:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name  = "app"
      image = "839063654285.dkr.ecr.ap-northeast-1.amazonaws.com/sasisuseso-maker/app"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          name          = "app-80-tcp"
          appProtocol   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/sasisuseso-maker-taskdef"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
          max-buffer-size       = "25m"
          mode                  = "non-blocking"
        }
        secretOptions = []
      }
      environment      = []
      environmentFiles = []
      essential        = true
      mountPoints      = []
      systemControls   = []
      ulimits          = []
      volumesFrom      = []
    }
  ])

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }
}
