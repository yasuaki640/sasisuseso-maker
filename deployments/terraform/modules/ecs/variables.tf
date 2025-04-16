variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "The container image to use for the application"
  type        = string
}
