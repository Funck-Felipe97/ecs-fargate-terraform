resource "aws_s3_bucket" "invoice-events" {
  bucket = "invoice-events"
  acl    = "private"
}

resource "aws_s3_bucket_notification" "invoice-events-notification" {
  bucket = aws_s3_bucket.invoice-events.id

  topic {
    topic_arn  = aws_sns_topic.s3-invoice-events.arn
    events     = ["s3:ObjectCreated:*"]
  }
}