/** Create S3 bucket
*/

terraform {
  required_version = ">= 0.11.12"
}

provider "aws" {
  version = ">= 2.3.0"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  enabled     = "${var.enabled == "true" ? true : false }"
}

resource "aws_s3_bucket" "bucket" {
  count         = "${local.enabled ? 1 : 0}"

  bucket        = "${var.bucket}"
  acl           = "private"
  force_destroy = "${var.force_destroy}"

  versioning {
    enabled = "${var.versioned}"
  }

  tags = "${merge(map(
		"terraform", "true",
                "created",   timestamp(),
		"user_id", " ${data.aws_caller_identity.current.user_id}",
		"Name",      format("%s", var.bucket)),
		"${var.extra_tags}"
		)}"
}

output "id" {
  value = "${join("", aws_s3_bucket.bucket.*.id)}"
}

output "arn" {
  value = "${join("", aws_s3_bucket.bucket.*.arn)}"
}
