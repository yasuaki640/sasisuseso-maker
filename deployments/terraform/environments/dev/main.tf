terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.81.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  name_prefix = "sasisuseso-maker-dev"
  tags = {
    Environment = "dev"
    Project     = "sasisuseso-maker"
  }
}

module "ecr" {
  source       = "../../modules/ecr"
  name         = "sasisuseso-maker/api"
  force_delete = true
}


module "vpc" {
  source = "../../modules/vpc"

  name            = "sasisuseso-maker-dev"
  cidr_block      = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  tags = {
    Environment = "dev"
    Project     = "sasisuseso-maker"
  }
}

module "app_sg" {
  source = "../../modules/security_group"

  name        = "sasisuseso-maker-dev-app-sg"
  description = "Security group for the sasisuseso-maker application"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 8080
      protocol                 = "tcp"
      description              = "Allow inbound traffic from ALB"
      source_security_group_id = module.alb_sg.id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "sasisuseso-maker"
  }
}

module "ecs" {
  source = "../../modules/ecs"

  name_prefix        = "sasisuseso-maker-dev"
  container_image    = module.ecr.repository_url
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.app_sg.id
  target_group_arn   = module.alb.blue_target_group_arn
  desired_count      = 1

  tags = {
    Environment = "dev"
    Project     = "sasisuseso-maker"
  }
}

module "alb_sg" {
  source = "../../modules/security_group"

  name        = "sasisuseso-maker-dev-alb-sg"
  description = "Security group for the sasisuseso-maker alb"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 8080
      protocol    = "tcp"
      description = "Allow HTTP inbound traffic"
      cidr_blocks = ["0.0.0.0/0"] # FIXME: Consider restricting this in production
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "sasisuseso-maker"
  }
}

module "alb" {
  source = "../../modules/alb"

  name_prefix        = "sasisuseso-maker-dev"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids # ALBはパブリックサブネットに配置
  security_group_ids = [module.alb_sg.id]
  target_port        = 8080    # アプリケーションのポート
  health_check_path  = "/ping" # アプリケーションのヘルスチェックパス

  tags = {
    Environment = "dev"
    Project     = "sasisuseso-maker"
  }
}

module "secret_manager" {
  source = "../../modules/secret_manager"

  name        = "${local.name_prefix}-example-secret"
  description = "Example secret for sasisuseso-maker dev environment"
  secret_string = jsonencode({
    DOCKERHUB_USERNAME = var.dockerhub_username
    DOCKERHUB_PASSWORD = var.dockerhub_password
  })
  tags = local.tags
}

module "codebuild" {
  source = "../../modules/codebuild"

  name_prefix                      = local.name_prefix
  aws_account_id                   = var.aws_account_id
  ecr_repository_name              = module.ecr.repository_name
  buildspec_path                   = "deployments/cicd/buildspec.yml"
  secret_manager_arn               = module.secret_manager.secret_arn

  tags = local.tags
}

module "codedeploy" {
  source = "../../modules/codedeploy"

  app_name                = "${local.name_prefix}-app"
  deployment_group_name   = "${local.name_prefix}-dg"
  ecs_cluster_name        = module.ecs.cluster_name
  ecs_service_name        = module.ecs.service_name
  alb_listener_arn        = module.alb.listener_arn
  blue_target_group_name  = module.alb.blue_target_group_name
  green_target_group_name = module.alb.green_target_group_name

  # tags は codedeploy モジュールには定義されていないためコメントアウト
  # tags = local.tags
}

module "codepipeline" {
  source = "../../modules/codepipeline"

  name_prefix            = local.name_prefix
  artifacts_bucket_name  = "${local.name_prefix}-artifacts"
  ecr_repository_arn     = module.ecr.repository_arn
  codebuild_project_name = module.codebuild.codebuild_project_name

  codestar_connection_arn = var.codestar_connection_arn
  repository_id           = "yasuaki640/sasisuseso-maker" # ご自身の環境に合わせて修正してください
  branch_name             = "main"

  ecs_container_name = "${local.name_prefix}-api-container"
  ecs_container_port = 8080 # module.ecs.container_port を参照するように変更も検討

  codedeploy_app_name              = module.codedeploy.codedeploy_app_name
  codedeploy_deployment_group_name = module.codedeploy.codedeploy_deployment_group_name

  tags = local.tags
}

