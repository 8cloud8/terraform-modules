terraform {
  required_version = ">= 0.11.2"
}

provider "aws" {
  version = ">= 2.1.0"
}

locals {
  enabled = "${var.enabled == "true" ? 1 : 0}"
}

data "aws_caller_identity" "current" {
  count = "${local.enabled}"
}

data "aws_region" "current" {
  count = "${local.enabled}"
}

data "aws_partition" "current" {
  count = "${local.enabled}"
}

output "account_id" {
  value = "${local.enabled > 0 ? join(",", data.aws_caller_identity.current.*.account_id) : ""}"
}

output "user_id" {
  value = "${local.enabled > 0 ? join(",", data.aws_caller_identity.current.*.user_id) : ""}"
}

output "region" {
  value = "${local.enabled > 0 ? join(",", data.aws_region.current.*.name) : ""}"
}

output "arn" {
  value = "${local.enabled > 0 ? join(",", data.aws_caller_identity.current.*.arn) : ""}"
}
