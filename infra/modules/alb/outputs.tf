output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.alb_tg.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the Application Load Balancer"
  value       = aws_lb.alb.zone_id
}
