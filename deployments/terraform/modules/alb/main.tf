resource "aws_lb" "main" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false # Set to true in production

  tags = merge(
    {
      "Name" = "${var.name_prefix}-alb"
    },
    var.tags,
  )
}

resource "aws_lb_target_group" "blue" {
  name        = "${var.name_prefix}-blue-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Use 'instance' if deploying to EC2 instances directly

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = "HTTP"
    matcher             = "200" # Expect HTTP 200 OK for healthy targets
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    {
      "Name" = "${var.name_prefix}-blue-tg"
    },
    var.tags,
  )
}

resource "aws_lb_target_group" "green" {
  name        = "${var.name_prefix}-green-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Use 'instance' if deploying to EC2 instances directly

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    {
      "Name" = "${var.name_prefix}-green-tg"
    },
    var.tags,
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn # Default to blue target group
  }

  tags = merge(
    {
      "Name" = "${var.name_prefix}-http-listener"
    },
    var.tags,
  )
}

# Optional: Add HTTPS listener (requires ACM certificate)
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08" # Choose an appropriate policy
#   certificate_arn   = var.certificate_arn # Add certificate_arn variable
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.blue.arn
#   }
#
#   tags = merge(
#     {
#       "Name" = "${var.name_prefix}-https-listener"
#     },
#     var.tags,
#   )
# }