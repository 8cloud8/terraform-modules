# NOTE: Organization policy can only be created from the master account

terraform {
  required_version = ">= 0.11.2"
}

provider "aws" {
  version = ">= 2.1.0"
}

data "aws_caller_identity" "current" {}

variable "organisations_policy_name" {
  description = "The name of organisation policy"
}

variable "organisations_policy_description" {
  default = "Default organisation policy description"
}

variable "organizations_policy_content" {
  description = "Default organisation policy content in JSON format"
  default = <<-EOF
  { "Version": "2012-10-17",
    "Statement": [
    {
      "Sid": "DenyAllOutsideEU",
      "Effect": "Deny",
      "NotAction": [
        "cloudfront:*",
        "iam:*",
	      "sts:*",
        "route53:*",
        "support:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "eu-central-1",
            "eu-west-1"
          ]
        }
      }
    }]
  }
  EOF
}

resource "aws_organizations_policy" "policy" {
  content     = "${var.organizations_policy_content}"
  description = "${var.organisations_policy_description}"
  name        = "${var.organisations_policy_name}"
}

output "arn" {
  value = "${aws_organizations_policy.policy.arn}"
}
