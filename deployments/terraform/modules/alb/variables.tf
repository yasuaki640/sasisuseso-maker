variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB (typically public subnets)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the ALB"
  type        = list(string)
}

variable "target_port" {
  description = "Port on which the targets receive traffic"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path for the health check"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port for the health check"
  type        = string
  default     = "traffic-port"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}