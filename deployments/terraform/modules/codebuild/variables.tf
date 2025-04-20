variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "Name of the S3 bucket to store CodeBuild artifacts"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  type        = string
}

variable "buildspec_path" {
  description = "Path to the buildspec file"
  type        = string
  default     = "deployments/cicd/buildspec.yml"
}

variable "repository_id" {
  description = "GitHub repository ID (e.g., 'username/repo')"
  type        = string
}

variable "branch_name" {
  description = "Branch name to build from"
  type        = string
  default     = "main"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}