# CodeBuild module for building and pushing Docker images to ECR

resource "aws_s3_bucket" "codebuild_bucket" {
  bucket        = var.artifacts_bucket_name
  force_destroy = true
}

resource "aws_iam_role" "codebuild_role" {
  name = "${var.name_prefix}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.name_prefix}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.codebuild_bucket.arn,
          "${aws_s3_bucket.codebuild_bucket.arn}/*"
        ]
      },
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "api_build" {
  name          = "${var.name_prefix}-build"
  description   = "Build project for ${var.name_prefix} API Docker image"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "10"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    type            = "LINUX_CONTAINER"
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    privileged_mode = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "ECR_REPOSITORY"
      value = var.ecr_repository_name
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.repository_id}.git"
    git_clone_depth = 1
    buildspec       = var.buildspec_path

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = var.branch_name

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.name_prefix}-build"
      stream_name = "build-log"
    }
  }

  tags = var.tags
}