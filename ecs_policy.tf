resource "aws_iam_role" "ecs-products-events-role" {
  name = "ecs-products-events-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs-products-events-policy" {
  name = "ecs-products-events-policy"
  role = aws_iam_role.ecs-products-events-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish",
        ]
        Effect   = "Allow"
        Resource = aws_sns_topic.products-events.id
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs-products-events-policy-4" {
  name = "ecs-products-events-policy-4"
  role = aws_iam_role.ecs-products-events-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeTags",
          "ecs:DeregisterContainerInstance",
          "ecs:DiscoverPollEndpoint",
          "ecs:Poll",
          "ecs:RegisterContainerInstance",
          "ecs:StartTelemetrySession",
          "ecs:UpdateContainerInstancesState",
          "ecs:Submit*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs-products-events-policy-5" {
  name = "ecs-products-events-policy-5"
  role = aws_iam_role.ecs-products-events-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "sqs:DeleteMessage",
            "sqs:GetQueueUrl",
            "sqs:ListQueues",
            "sqs:ChangeMessageVisibility",
            "sqs:SendMessageBatch",
            "sqs:ReceiveMessage",
            "sqs:SendMessage",
            "sqs:GetQueueAttributes",
            "sqs:ListQueueTags",
            "sqs:ListDeadLetterSourceQueues",
            "sqs:DeleteMessageBatch",
            "sqs:ChangeMessageVisibilityBatch",
            "sqs:SetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = aws_sqs_queue.s3-invoice-events.arn
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs-products-events-policy-6" {
  name = "ecs-products-events-policy-6"
  role = aws_iam_role.ecs-products-events-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "s3:*"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.invoice-events.arn
      },
    ]
  })
}