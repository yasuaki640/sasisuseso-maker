variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "artifacts_bucket_arn" {
  description = "ARN of the S3 bucket to store CodeBuild artifacts"
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "buildspec_path" {
  description = "Path to the buildspec file"
  type        = string
  default     = "deployments/cicd/buildspec.yml"
}

variable "secret_manager_arn" {
  description = "ARN of the AWS Secrets Manager secret"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
