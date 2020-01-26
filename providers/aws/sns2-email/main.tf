terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS Region, .g. 'eu-west-1'"
}

variable "name" {}
variable "delivery_policy" {}
variable "alarms_email" {}

variable "tags" {
  default = {
    Terraform = "true"
  }
}

locals {
  tags = merge(var.tags, map("Terraform", "true"), map("Name", var.name))
}

resource "aws_sns_topic" "this" {
  name            = var.name
  delivery_policy = var.delivery_policy

  provisioner "local-exec" {
    command = "aws sns subscribe --region ${var.region} --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }

  tags = local.tags
}

output "sns_arn" {
  value = aws_sns_topic.this.arn
}
