terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.81.0"
    }
  }
}

module "ecr" {
  source = "../../modules/ecr"
  name   = "sasisuseso-maker/api"
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

module "ecs" {
  source = "../../modules/ecs"

  name_prefix        = "sasisuseso-maker-dev"
  container_image    = module.ecr.repository_url
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.app_sg.id

  tags = {
    Environment = "dev"
    Project     = "sasisuseso-maker"
  }
}
