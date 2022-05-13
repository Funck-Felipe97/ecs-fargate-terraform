## Products events topic config
resource "aws_sns_topic" "products-events" {
  name = "products-events"
}

resource "aws_sns_topic_subscription" "products-events-sqs-subscription" {
  topic_arn = aws_sns_topic.products-events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.products-events.arn
}

## S3 events topic config
resource "aws_sns_topic" "s3-invoice-events" {
  name   = "s3-invoice-events"
  policy = <<POLICY
  {
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-invoice-events",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.invoice-events.arn}"}
        }
    }]
  }
  POLICY
}

resource "aws_sns_topic_subscription" "s3-invoice-events-sqs-subscription" {
  topic_arn = aws_sns_topic.s3-invoice-events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.s3-events-events.arn
}