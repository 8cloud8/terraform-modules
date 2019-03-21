# Note: Account management must be done from the organization's master account.

terraform {
  required_version = ">= 0.11.2"
}

provider "aws" {
  version = ">= 2.1.0"
}

data "aws_caller_identity" "current" {}

variable "name" {
  description = "Name of organisational account. Must consist of uppercase letters, lowercase letters, digits with no spaces, and any of the following characters: `=,.@-`"
}

variable "email" {
  description = "The email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account."
}

variable "role_name" {
  default = ""
}

resource "aws_organizations_account" "account" {
  name                       = "${var.name}"
  email                      = "${var.email}"
  iam_user_access_to_billing = "DENY"
  role_name                  = "${var.role_name}"
}

output "arn" {
  value = "${aws_organizations_account.account.arn}"
}
