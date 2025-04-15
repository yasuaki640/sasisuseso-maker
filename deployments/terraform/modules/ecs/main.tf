resource "aws_ecs_cluster" "foo" {
  name = "${var.name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# TODO task definition