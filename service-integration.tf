#################################################################################
#  Create SQS
#################################################################################

resource "aws_sqs_queue" "wtc_tf_sqs" {
  name                      = "ce7_wtc_tf_sqs"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = "Dev"
  }
}

#################################################################################
# Create SNS
#################################################################################

resource "aws_sns_topic" "wtc_tf_sns" {
  name = "ce7_wtc_tf_sns"
}

#################################################################################
# Create SNS-SQS Subscription
#################################################################################

resource "aws_sns_topic_subscription" "wtc_tf_sns-sqs-subscription" {
  topic_arn = aws_sns_topic.wtc_tf_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.wtc_tf_sqs.arn
}

#################################################################################
# Create SNS-Email Subscription
#################################################################################

resource "aws_sns_topic_subscription" "wtc_tf_sns-sns-email-subscription" {
  topic_arn = aws_sns_topic.wtc_tf_sns.arn
  protocol  = "email"
  endpoint  = "demo@hotmail.com"
}

#################################################################################
# Granting SQS permission to consume messages from SNS
#################################################################################

resource "aws_sqs_queue_policy" "wtc_tf_sqs-policy" {
  queue_url = aws_sqs_queue.wtc_tf_sqs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.wtc_tf_sqs.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.wtc_tf_sns.arn
          }
        }
      }
    ]
  })
}
