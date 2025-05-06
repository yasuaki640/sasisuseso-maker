variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "Name of the S3 bucket to store CodePipeline artifacts"
  type        = string
}

variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection to GitHub"
  type        = string
}

variable "repository_id" {
  description = "GitHub repository ID (e.g., 'username/repo')"
  type        = string
}

variable "branch_name" {
  description = "Branch name to trigger the pipeline"
  type        = string
  default     = "main"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  type        = string
}

variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "ecs_container_name" {
  description = "The name of the ECS container defined in the task definition"
  type        = string
}

variable "ecs_container_port" {
  description = "The container port from the ECS task definition, used for CodeDeploy AppSpec"
  type        = number
}
