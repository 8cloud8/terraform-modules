/** Creates IAM system user
*
*/

terraform {
  required_version = ">= 0.11.2"
}

provider "aws" {
  version = ">= 2.1.0"
}

resource "aws_iam_user" "iam_system_user" {
  count         = "${var.enabled == "true" ? 1 : 0}"

  name          = "${var.name}"
  path          = "${var.path}"
  force_destroy = "${var.force_destroy}"

  tags = "${merge(map(
		"terraform", "true",
		"Name", format("%s", var.name)),
		"${var.extra_tags}")
    }"
}

resource "aws_iam_access_key" "iam_system_user" {
  count = "${var.enabled == "true" ? 1 : 0}"
  user  = "${aws_iam_user.iam_system_user.name}"
}

output "user_name" {
  value       = "${join("", aws_iam_user.iam_system_user.*.name)}"
  description = "IAM user name"
}

output "user_arn" {
  value       = "${join("", aws_iam_user.iam_system_user.*.arn)}"
  description = "ARN assigned by AWS for this user"
}

output "user_unique_id" {
  value       = "${join("", aws_iam_user.iam_system_user.*.unique_id)}"
  description = "Unique ID assigned by AWS"
}

output "access_key_id" {
  value       = "${join("", aws_iam_access_key.iam_system_user.*.id)}"
  description = "The access key ID"
}

output "secret_access_key" {
  sensitive   = true
  value       = "${join("", aws_iam_access_key.iam_system_user.*.secret)}"
  description = "The secret access key."
}
