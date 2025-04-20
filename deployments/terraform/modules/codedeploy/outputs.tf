output "codedeploy_app_name" {
  description = "Name of the CodeDeploy application"
  value       = aws_codedeploy_app.app.name
}

output "codedeploy_app_arn" {
  description = "ARN of the CodeDeploy application"
  value       = aws_codedeploy_app.app.arn
}

output "deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
}

output "deployment_group_id" {
  description = "ID of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.deployment_group.id
}

output "codedeploy_role_arn" {
  description = "ARN of the IAM role for CodeDeploy"
  value       = aws_iam_role.codedeploy_role.arn
}

output "codedeploy_role_name" {
  description = "Name of the IAM role for CodeDeploy"
  value       = aws_iam_role.codedeploy_role.name
}