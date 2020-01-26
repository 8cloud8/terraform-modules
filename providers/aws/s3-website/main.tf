/**
 * ## S3 Bucket to run SPA
 *
**/

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS Region, eg. 'eu-west-1'"
}

variable "tags" {
  default = {
    terraform = "true"
  }
}

variable "bucket_name" {
  description = "The name of s3 bucket to create"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "build_command" {
  description = "Eg. 'cd my-app && npm i && npm run build && echo build done'"
  default     = ""
}

variable "force_destroy" {
  description = "Whether to allow a forceful destruction of this bucket"
  default     = false
  type        = bool
}

variable "deploy_command" {
  description = "Eg. 'aws s3 sync my-app/build/ s3://var.bucket_name && echo deploy done'"
  default     = ""
}

locals {
  bucket_name    = format("%s", var.bucket_name)
  enabled        = var.enabled == "true" ? true : false
  tags           = merge(var.tags, map("Name", local.bucket_name))
  build_command  = var.build_command
  deploy_command = var.deploy_command
}

data "aws_iam_policy_document" "s3-public-read-access" {
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      format("arn:aws:s3:::%s/*", local.bucket_name),
    ]
  }
}

resource "aws_s3_bucket" "this" {
  count = local.enabled == true ? 1 : 0

  bucket        = local.bucket_name
  acl           = "public-read"
  force_destroy = var.force_destroy
  policy        = data.aws_iam_policy_document.s3-public-read-access.json

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = local.tags
}

resource "null_resource" "build" {
  count = local.enabled == true ? 1 : 0
  provisioner "local-exec" {
    command = local.build_command
  }

  depends_on = [aws_s3_bucket.this]
}

resource "null_resource" "deploy" {
  count = local.enabled == true ? 1 : 0
  provisioner "local-exec" {
    command = local.deploy_command
  }

  depends_on = [null_resource.build]
}

output "id" {
  value = join("", aws_s3_bucket.this.*.id)
}

output "arn" {
  value = join("", aws_s3_bucket.this.*.arn)
}
