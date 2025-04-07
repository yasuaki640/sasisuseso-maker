
import {
  id = "sasisuseso-maker"
  to = aws_ecs_cluster.main
}
resource "aws_ecs_cluster" "main" {
  name = "sasisuseso-maker"
}

