output "Postgres_endpoint" {
  value = aws_db_instance.default.endpoint
} 

output "ALB_endpoint-frontend" {
  value = aws_alb.front_end.dns_name
} 

output "ALB_endpoint-web" {
  value = aws_alb.web.dns_name
} 