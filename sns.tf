resource "aws_sns_topic" "products-events" {
  name = "products-events"
}

resource "aws_sns_topic_subscription" "products-events-sqs-subscription" {
  topic_arn = aws_sns_topic.products-events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.products-events.arn
}