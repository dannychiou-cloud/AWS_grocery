resource "aws_sns_topic" "grocerymate_alerts" {
  name = "terraform-grocerymate-alerts"

  tags = {
    Name = "terraform-grocerymate-alerts"
  }
}

# Email subscription for the SNS topic
resource "aws_sns_topic_subscription" "grocerymate_email_alert" {
  topic_arn = aws_sns_topic.grocerymate_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
# CloudWatch alarm for high EC2 CPU utilization
resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name        = "terraform-grocerymate-ec2-high-cpu"
  alarm_description = "Alert when GroceryMate EC2 CPU utilization is high"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"

  period    = 300
  statistic = "Average"
  threshold = 70

  dimensions = {
    InstanceId = aws_instance.grocerymate_ec2.id
  }

  alarm_actions = [
    aws_sns_topic.grocerymate_alerts.arn
  ]

  treat_missing_data = "notBreaching"
}