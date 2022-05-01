resource "aws_cloudwatch_log_group" "products-api-logs" {
  name              = "/fargate/service/products-api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "events-api-logs" {
  name              = "/fargate/service/events-api"
  retention_in_days = 1
}