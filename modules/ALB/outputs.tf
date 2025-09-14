output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.ecs_alb.dns_name
}

output "blue_target_group_arn" {
  description = "Blue Target Group ARN"
  value       = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  description = "Green Target Group ARN"
  value       = aws_lb_target_group.green.arn
}

output "alb_listener_arn" {
  description = "ALB Listener ARN"
  value       = aws_lb_listener.http.arn
}


output "blue_target_group_name" {
  description = "Blue Target Group Name"
  value       = aws_lb_target_group.blue.name
  
}

output "green_target_group_name" {
  description = "Green Target Group Name"
  value       = aws_lb_target_group.green.name
}