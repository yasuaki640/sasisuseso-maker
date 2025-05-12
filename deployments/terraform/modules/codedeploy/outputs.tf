output "codedeploy_app_name" {
  description = "The name of the CodeDeploy application."
  value       = aws_codedeploy_app.this.name
}

output "codedeploy_deployment_group_name" {
  description = "The name of the CodeDeploy deployment group."
  value       = aws_codedeploy_deployment_group.this.deployment_group_name
}

output "codedeploy_role_arn" {
  description = "The ARN of the CodeDeploy IAM role."
  value       = aws_iam_role.codedeploy_role.arn
}
