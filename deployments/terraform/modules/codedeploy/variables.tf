variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "listener_arn" {
  description = "ARN of the load balancer listener"
  type        = string
}

variable "blue_target_group_name" {
  description = "Name of the blue target group"
  type        = string
}

variable "green_target_group_name" {
  description = "Name of the green target group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_notifications" {
  description = "Whether to enable deployment notifications"
  type        = bool
  default     = false
}

variable "notification_target_arn" {
  description = "ARN of the SNS topic for notifications"
  type        = string
  default     = ""
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  type        = string
}