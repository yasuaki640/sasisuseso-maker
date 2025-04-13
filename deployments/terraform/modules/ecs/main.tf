//
# Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
# ~ update in-place
# -/+ destroy and then create replacement
#
# Terraform will perform the following actions:
#
# # aws_ecs_cluster.main will be updated in-place
# ~ resource "aws_ecs_cluster" "main" {
# id       = "arn:aws:ecs:ap-northeast-1:839063654285:cluster/sasisuseso-maker"
# name     = "sasisuseso-maker"
# tags     = {}
# # (2 unchanged attributes hidden)
#
# + configuration {
# + execute_command_configuration {
# + logging = "DEFAULT"
# }
# }
#
# - setting {
# - name  = "containerInsights" -> null
# - value = "enhanced" -> null
# }
# + setting {
# + name  = "containerInsights"
# + value = "disabled"
# }
# }
#
# # aws_ecs_service.api must be replaced
# # (imported from "sasisuseso-maker/api")
# # Warning: this will destroy the imported resource
# -/+ resource "aws_ecs_service" "api" {
# availability_zone_rebalancing      = "ENABLED"
# cluster                            = "arn:aws:ecs:ap-northeast-1:839063654285:cluster/sasisuseso-maker"
# deployment_maximum_percent         = 200
# deployment_minimum_healthy_percent = 100
# desired_count                      = 1
# enable_ecs_managed_tags            = true
# enable_execute_command             = false
# health_check_grace_period_seconds  = 0
# ~ iam_role                           = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS" -> (known after apply)
# ~ id                                 = "arn:aws:ecs:ap-northeast-1:839063654285:service/sasisuseso-maker/api" -> (known after apply)
# + launch_type                        = "FARGATE" # forces replacement
# name                               = "api"
# platform_version                   = "LATEST"
# propagate_tags                     = "NONE"
# scheduling_strategy                = "REPLICA"
# - tags                               = {} -> null
# ~ tags_all                           = {} -> (known after apply)
# ~ task_definition                    = "sasisuseso-maker-api-taskdef:2" -> "api:1"
# ~ triggers                           = {} -> (known after apply)
# + wait_for_steady_state              = false
#
# - alarms {
# - alarm_names = [] -> null
# - enable      = false -> null
# - rollback    = false -> null
# }
#
# - capacity_provider_strategy { # forces replacement
# - base              = 0 -> null
# - capacity_provider = "FARGATE" -> null
# - weight            = 1 -> null
# }
#
# - deployment_circuit_breaker {
# - enable   = true -> null
# - rollback = true -> null
# }
#
# - deployment_controller {
# - type = "ECS" -> null
# }
#
# ~ network_configuration {
# assign_public_ip = true
# - security_groups  = [
# - "sg-0e2078af370b03f53",
# ] -> null
# - subnets          = [
# - "subnet-54f87b1c",
# - "subnet-b3ae2498",
# - "subnet-f98c71a3",
# ] -> null
# }
# }

import {
  id = "sasisuseso-maker"
  to = aws_ecs_cluster.main
}
resource "aws_ecs_cluster" "main" {
  name = "sasisuseso-maker"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {}
}

import {
  id = "sasisuseso-maker/api"
  to = aws_ecs_service.api
}
resource "aws_ecs_service" "api" {
  name            = "api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = "api:1"
  launch_type     = "FARGATE"

  availability_zone_rebalancing     = "ENABLED"
  desired_count                     = 1
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 0
  platform_version                  = "LATEST"
  propagate_tags                    = "NONE"

  wait_for_steady_state = false

  alarms {
    alarm_names = []
    enable   = false
    rollback = false
  }

  capacity_provider_strategy {
    base = 0
    capacity_provider = "FARGATE"
    weight = 1
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = []
    subnets          = []
  }
}