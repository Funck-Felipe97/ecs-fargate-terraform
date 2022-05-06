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
        Resource = aws_sqs_queue.products-events.arn
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs-products-events-policy-3" {
  name = "ecs-products-events-policy-3"
  role = aws_iam_role.ecs-products-events-role-2.id

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

resource "aws_iam_role_policy" "dynamodb-product-events-policy" {
   name = "dynamodb-product-events-policy"
   role = aws_iam_role.ecs-products-events-role-2.id
   policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
       {
            Action = [
                "dynamodb:*"
            ]
            Effect = "Allow"
            Resource = aws_dynamodb_table.products-events.arn
        },
        ]
    })

}