resource "aws_sqs_queue" "products-events" {
  name                      = "products-events"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.products-events-dlq.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue" "products-events-dlq" {
  name = "products-events-dlq"
}

resource "aws_sqs_queue_policy" "products-events-policy" {
  queue_url = aws_sqs_queue.products-events.id

  policy = <<POLICY
            {
            "Version": "2012-10-17",
            "Id": "sqspolicy",
            "Statement": [
                {
                "Sid": "1",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "sqs:SendMessage",
                "Resource": "${aws_sqs_queue.products-events.arn}",
                "Condition": {
                    "ArnEquals": {
                    "aws:SourceArn": "${aws_sns_topic.products-events.arn}"
                    }
                }
                }
            ]
            }
            POLICY
}