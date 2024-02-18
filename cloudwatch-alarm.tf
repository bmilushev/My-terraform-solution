#Create CloudWatch alarm for ALB requests
resource "aws_cloudwatch_metric_alarm" "alb_requests_alarm" {
  alarm_name          = var.cloudwatch_alarm_name
  comparison_operator = var.cloudwatch_comparison_operator
  evaluation_periods  = var.cloudwatch_evaluation_periods
  metric_name         = var.cloudwatch_metric_name
  namespace           = var.cloudwatch_namespace
  period              = var.cloudwatch_period
  statistic           = var.cloudwatch_statistic
  threshold           = var.cloudwatch_threshold
  alarm_description   = var.cloudwatch_alarm_description
  alarm_actions       = [aws_sns_topic.alb_notification_topic.id]

  dimensions = {
    LoadBalancer = aws_lb.my_load_balancer.id
  }
}

#Create SNS topic for the CW Alarm
resource "aws_sns_topic" "alb_notification_topic" {
  name = var.sns_topic_name
}

#Create SNS subscription 
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alb_notification_topic.arn
  protocol  = "email"
  endpoint  = var.sns_endpoint_email
}

resource "aws_iam_policy" "sns_publish_policy" {
  name        = "sns-publishh-policy"
  description = "IAM policy for SNS to publish messages to the topic"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sns:Publish",
      Resource = aws_sns_topic.alb_notification_topic.arn
    }]
  })
}

resource "aws_iam_role" "sns_publish_role" {
  name = "sns-publish-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "sns.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "sns_publish_role_attachment" {
  role       = aws_iam_role.sns_publish_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}
