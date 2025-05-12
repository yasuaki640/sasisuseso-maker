variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection to GitHub"
  type        = string
}

variable "secret_manager_secret_string" {
  description = "The secret string for the Secret Manager"
  type        = string
  sensitive   = true
}
