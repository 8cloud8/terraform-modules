resource aws_cloudwatch_log_group "log_group" {

  count             = local.enabled ? 1 : 0
  name              = format("/ecs/fargate/%s", local.name)
  retention_in_days = 14
  tags              = local.tags
}

resource aws_cloudwatch_log_stream "log_stream" {
  count          = local.enabled ? 1 : 0
  name           = format("%s-log-stream", local.name)
  log_group_name = join("", aws_cloudwatch_log_group.log_group.*.name)
}
