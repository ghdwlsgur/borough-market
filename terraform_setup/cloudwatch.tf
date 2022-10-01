module "ecs_service_alarms" {
  namespace                             = "borough-market"
  source                                = "cloudposse/ecs-cloudwatch-sns-alarms/aws"
  stage                                 = "test"
  name                                  = local.aws_ecs_service_stack_name
  cluster_name                          = local.aws_ecs_cluster_name
  service_name                          = local.aws_ecs_service_name
  memory_utilization_high_alarm_actions = [aws_sns_topic.send-alert-message.arn]
  memory_utilization_high_ok_actions    = [aws_sns_topic.send-alert-message.arn]
  cpu_utilization_high_alarm_actions    = [aws_sns_topic.send-alert-message.arn]
  cpu_utilization_high_ok_actions       = [aws_sns_topic.send-alert-message.arn]
}
