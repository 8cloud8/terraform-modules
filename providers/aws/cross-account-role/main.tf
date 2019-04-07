terraform {
  required_version = ">= 0.11.12"
}

provider "aws" {
  version = ">= 2.3.0"
}

locals {
  enabled     = "${var.enabled == "true" ? true : false }"
  require_mfa = "${var.require_mfa == "true" ? true : false}"
  name        = "${var.name}"
}

resource "aws_iam_role" "cross_account_assume_role" {
  count = "${local.enabled ? 1 : 0}"

  name               = "${var.name}"
  assume_role_policy = "${local.require_mfa == true ? data.aws_iam_policy_document.cross_account_assume_role_mfa.json : data.aws_iam_policy_document.cross_account_assume_role.json}"
  description        = "${var.description}"

  #max_session_duration = "${var.max_session_duration}"
  tags = "${merge(map(
		"terraform", "true",
                "created", timestamp(),
		"Name", format("%s", var.name)),
                "${var.extra_tags}")
            	}"
}

resource "aws_iam_role_policy_attachment" "cross_account_assume_role" {
  count = "${length(var.policy_arns)}"

  role       = "${aws_iam_role.cross_account_assume_role.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
}

resource "aws_iam_role_policy" "iam_policy" {
  count = "${length(var.policy_json) > 0 ? 1 : 0}"

  name   = "${var.name}-IAMPolicy"
  role   = "${aws_iam_role.cross_account_assume_role.name}"
  policy = "${var.policy_json}"
}
