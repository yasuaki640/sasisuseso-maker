output "codepipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.app_pipeline.arn
}

output "codepipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.app_pipeline.name
}


output "artifacts_bucket_arn" {
  description = "ARN of the S3 bucket for CodePipeline artifacts"
  value       = aws_s3_bucket.codepipeline_bucket.arn
}

output "artifacts_bucket_name" {
  description = "Name of the S3 bucket for CodePipeline artifacts"
  value       = aws_s3_bucket.codepipeline_bucket.bucket
}
