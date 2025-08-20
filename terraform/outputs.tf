output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value = aws_lb.main.dns_name
}

output "load_balancer_url" {
  description = "URL of the load balancer"
  value = "http://${aws_lb.main.dns_name}"
}

output "dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.nginxposp.name
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile for EC2"
  value       = aws_iam_instance_profile.cloudwatch_profile.name
}