# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
#resource "aws_cloudwatch_log_group" "myapp_log_group" {
#  name              = "awslogs-celery-beat"
#  retention_in_days = 3
#
#  tags = {
#    Name = "cb-log-group"
#  }
#}
#
#resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
#  name           = "ecs"
#  log_group_name = aws_cloudwatch_log_group.myapp_log_group.name
#}