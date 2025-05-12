variable "app_name" {
  description = "The name of the CodeDeploy application."
  type        = string
}

variable "deployment_group_name" {
  description = "The name of the CodeDeploy deployment group."
  type        = string
}

variable "deployment_config_name" {
  description = "The deployment configuration name."
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "alb_listener_arn" {
  description = "The ARN of the ALB listener."
  type        = string
}

variable "blue_target_group_name" {
  description = "The name of the blue target group."
  type        = string
}

variable "green_target_group_name" {
  description = "The name of the green target group."
  type        = string
}

variable "termination_wait_time_in_minutes" {
  description = "The number of minutes to wait before terminating the blue instances after a successful deployment."
  type        = number
  default     = 5
}