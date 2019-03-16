terraform {
  required_version = ">= 0.11.2"
}

provider "aws" {
  version = ">= 2.1.0"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "user_id" {
  value = "${data.aws_caller_identity.current.user_id}"
}

output "region" {
  value = "${data.aws_region.current.name}"
}

output "arn" {
  value = "${data.aws_caller_identity.current.arn}"
}
