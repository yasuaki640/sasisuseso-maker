output "codebuild_project_arn" {
  description = "ARN of the CodeBuild project"
  value       = aws_codebuild_project.api_build.arn
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.api_build.name
}

output "artifacts_bucket_arn" {
  description = "ARN of the S3 bucket for CodeBuild artifacts"
  value       = aws_s3_bucket.codebuild_bucket.arn
}

output "artifacts_bucket_name" {
  description = "Name of the S3 bucket for CodeBuild artifacts"
  value       = aws_s3_bucket.codebuild_bucket.bucket
}

output "codebuild_role_arn" {
  description = "ARN of the IAM role for CodeBuild"
  value       = aws_iam_role.codebuild_role.arn
}

output "codebuild_role_name" {
  description = "Name of the IAM role for CodeBuild"
  value       = aws_iam_role.codebuild_role.name
}