# variable "project_name" {
#   description = "Name of the project"
#   type        = string
# }
#
# variable "task_cpu" {
#   description = "CPU units for the ECS task"
#   type        = number
#   default     = 256
# }
#
# variable "task_memory" {
#   description = "Memory for the ECS task in MiB"
#   type        = number
#   default     = 512
# }
#
# variable "container_name" {
#   description = "Name of the container"
#   type        = string
# }
#
# variable "container_image" {
#   description = "Docker image for the container"
#   type        = string
# }
#
# variable "container_port" {
#   description = "Port exposed by the container"
#   type        = number
#   default     = 8080
# }
#
# variable "desired_count" {
#   description = "Desired number of tasks"
#   type        = number
#   default     = 1
# }
#
# variable "subnet_ids" {
#   description = "List of subnet IDs for the ECS tasks"
#   type        = list(string)
# }