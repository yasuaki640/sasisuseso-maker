variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "The container image to use for the application"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs to launch the ECS service in"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs to attach to the ECS service"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group to associate with the ECS service"
  type        = string
}
