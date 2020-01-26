/**
 * Creates a s3 bucket for (server access logs)[https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html]
**/

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS Region, .eg. 'eu-west-1'"
}

variable "name" {
  description = "The name of s3 bucket to create"
}

variable "tags" {
  default = {
    terraform = "true"
  }
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "account_id" {
  description = "Override which account id should be able to put the logs into s3 bucket (default: use this account)"
  default = ""
}

variable "logs_expiration_enabled" {
  default = false
}

variable "logs_expiration_days" {
  default = 30
}

data "aws_caller_identity" "current" {}

data "template_file" "policy" {
  template = file("${path.module}/policy.json")

  vars = {
    bucket     = local.name
    account_id = local.account_id
  }
}

locals {
  enabled    = var.enabled == "true" ? true : false
  name       = format("%s-logs", var.name)
  account_id = coalesce(var.account_id, data.aws_caller_identity.current.account_id)
  tags       = var.tags
}

resource "aws_s3_bucket" "this" {
  count  = local.enabled ? 1 : 0
  bucket = local.name

  lifecycle_rule {
    id      = "logs-expiration"
    prefix  = ""
    enabled = var.logs_expiration_enabled

    expiration {
      days = var.logs_expiration_days
    }
  }

  policy = data.template_file.policy.rendered
  tags   = merge(local.tags, map("Name", format("%s-%s", var.name, "log")))
}

output "id" {
  value = join("", aws_s3_bucket.this.*.id)
}

output "arn" {
  value = join("", aws_s3_bucket.this.*.arn)
}
