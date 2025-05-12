variable "name" {
  description = "The name of the secret"
  type        = string
}

variable "description" {
  description = "The description of the secret"
  type        = string
  default     = null
}

variable "secret_string" {
  description = "The secret string"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the secret"
  type        = map(string)
  default     = {}
}