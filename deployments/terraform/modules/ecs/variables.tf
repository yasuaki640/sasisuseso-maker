variable "name_prefix" {
  description = "Prefix for naming ECS resources"
  type        = string
}

variable "container_image" {
  description = "Docker image URL for the container"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ECS cluster will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS service"
  type        = list(string)
}

variable "app_sg_id" {
  description = "ID of the security group for the application"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group for the ECS service"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8080
}

variable "cpu" {
  description = "CPU units for the ECS task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (in MiB) for the ECS task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of tasks for the ECS service"
  type        = number
  default     = 1
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
