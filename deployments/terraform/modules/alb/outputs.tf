output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "lb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_lb.main.zone_id
}

output "listener_arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

# output "https_listener_arn" {
#   description = "The ARN of the HTTPS listener"
#   value       = aws_lb_listener.https.arn
# }

output "blue_target_group_arn" {
  description = "The ARN of the blue target group"
  value       = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  description = "The ARN of the green target group"
  value       = aws_lb_target_group.green.arn
}

output "blue_target_group_name" {
  description = "The Name of the blue target group"
  value       = aws_lb_target_group.blue.name
}

output "green_target_group_name" {
  description = "The Name of the green target group"
  value       = aws_lb_target_group.green.name
}