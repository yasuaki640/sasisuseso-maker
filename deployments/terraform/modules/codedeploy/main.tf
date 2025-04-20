# CodeDeploy module for ECS deployment

# IAM role for CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name = "${var.name_prefix}-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AWS managed policy for CodeDeploy
resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# CodeDeploy application
resource "aws_codedeploy_app" "app" {
  name             = "${var.name_prefix}-app"
  compute_platform = "ECS"
}

# CodeDeploy deployment group
resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "${var.name_prefix}-deployment-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_arn]
      }

      target_group {
        name = var.blue_target_group_name
      }

      target_group {
        name = var.green_target_group_name
      }
    }
  }

  tags = var.tags
}

# Add a notification rule for CodeDeploy (optional)
resource "aws_codestarnotifications_notification_rule" "deployment_notification" {
  count          = var.enable_notifications ? 1 : 0
  detail_type    = "BASIC"
  event_type_ids = ["codedeploy-application-deployment-succeeded", "codedeploy-application-deployment-failed"]
  name           = "${var.name_prefix}-deployment-notification"
  resource       = aws_codedeploy_app.app.arn

  target {
    address = var.notification_target_arn
    type    = "SNS"
  }

  tags = var.tags
}