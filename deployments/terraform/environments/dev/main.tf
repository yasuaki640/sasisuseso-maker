terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.81.0"
    }
  }
}

module "ecs" {
  source          = "../../modules/ecs"
  name            = "sasisuseso-maker"
  container_image = "839063654285.dkr.ecr.ap-northeast-1.amazonaws.com/sasisuseso-maker/app:latest"
}
