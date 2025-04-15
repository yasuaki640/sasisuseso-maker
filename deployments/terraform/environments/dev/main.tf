terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.81.0"
    }
  }
}

module "ecs" {
  source = "../../modules/ecs"
  name   = "sasisuseso-maker"
}