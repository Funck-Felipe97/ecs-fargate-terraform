resource "aws_iam_role" "ecs-products-events-role-2" {
  name = "ecs-products-events-role-2"

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

resource "aws_iam_role_policy" "ecs-products-events-policy-2" {
  name = "ecs-products-events-policy-2"
  role = aws_iam_role.ecs-products-events-role-2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:PurgeQueue",
          "sqs:ListQueues",
          "sqs:DeleteMessage"
        ]
        Effect   = "Allow"
        Resource = aws_sqs_queue.products-events.arn
      },
    ]
  })
}