/*
* https://www.terraform.io/docs/providers/aws/r/codedeploy_deployment_group.html
*/

terraform {
  required_version = ">= 0.12"
}

variable deployment_config_name {
  description = "The name of the group's deployment config"
  default     = "CodeDeployDefault.OneAtATime"
}

variable target_group_name {
  description = "The name of existing target group to use in codedeployment group"
  default     = ""
}

variable autoscaling_groups {
  description = "The list of autoscaling groups to use with codedeployment group"
  type    = list(string)
  default = []
}

variable service_role_arn {
  description = "The name of IAM service role to use with codedeployment group"
  defailt = ""
}

variable name {
  description = "The name of codedeployment group to create"
}

data "aws_caller_identity" "current" {}

locals {
  name                   = var.name
  account_id             = data.aws_caller_identity.current.account_id
  deployment_group_name  = format("%s-%s-deployment-group", local.platform, local.name)
  service_role_arn       = var.service_role_arn
  deployment_config_name = var.deployment_config_name
  platform               = "Server"
  autoscaling_groups     = var.autoscaling_groups
  service_role_arn       = coalesce(var.service_role_arn,format("arn:aws:iam::%s:role/codeDeploy",local.account_id))
}

resource aws_codedeploy_app "this" {
  compute_platform = local.platform
  name             = local.name
}

resource aws_codedeploy_deployment_group "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = local.deployment_group_name
  service_role_arn       = local.service_role_arn
  deployment_config_name = local.deployment_config_name

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  autoscaling_groups = local.autoscaling_groups

  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

output "id" {
  description = "Codedeploy id"
  value       = aws_codedeploy_deployment_group.this.id
}

output "codedeploy_deployment_group_name" {
  description = "Codedeployment group name"
  value       = aws_codedeploy_app.this.name
}
