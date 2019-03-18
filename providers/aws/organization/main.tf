# NOTE: Organization can only be created from the master account
# https://www.terraform.io/docs/providers/aws/r/organizations_organization.html

terraform {
  required_version = ">= 0.11.2"
}

provider "aws" {
  version = ">= 2.1.0"
}

data "aws_caller_identity" "current" {}

variable "organization_feature_set" {
  description = "Can be either `ALL` (default) or `CONSOLIDATED_BILLING`"
  default     = "ALL"
}

resource "aws_organizations_organization" "organization" {
  feature_set = "${var.organization_feature_set}"
}

output "id" {
  value = "${aws_organizations_organization.organization.id}"
}

output "arn" {
  value = "${aws_organizations_organization.organization.arn}"
}

output "master_account_id" {
  value = "${aws_organizations_organization.organization.master_account_id}"
}

output "master_account_arn" {
  value = "${aws_organizations_organization.organization.master_account_arn}"
}

output "master_account_email" {
  value = "${aws_organizations_organization.organization.master_account_email}"
}
