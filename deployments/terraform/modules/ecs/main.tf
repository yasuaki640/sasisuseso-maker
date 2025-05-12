resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name_prefix}-ecsTaskExecutionRole"
  tags = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "api_logs" {
  name = "/ecs/${var.name_prefix}"
  tags = var.tags

  retention_in_days = 3
}

resource "aws_ecs_task_definition" "api" {
  family                   = "${var.name_prefix}-api-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  tags                     = var.tags

  container_definitions = jsonencode([
    {
      name      = "${var.name_prefix}-api-container"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      # Basic logging configuration - adjust as needed
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.name_prefix}"
          "awslogs-region"        = data.aws_region.current.name # Assumes region is configured
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "api" {
  name            = "${var.name_prefix}-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  tags            = var.tags

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.app_sg_id]
    assign_public_ip = true # Set to false if using a load balancer in public subnets
  }

  load_balancer {
    target_group_arn = var.target_group_arn # Add target_group_arn variable
    container_name   = "${var.name_prefix}-api-container"
    container_port   = var.container_port
  }

  # Ensure the task execution role policy is attached before creating the service
  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}
