data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cross_account_assume_role" {
  #count = "${local.enabled && local.require_mfa == false ? 1 : 0}"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${var.trust_account_ids}"]
    }
  }
}

data "aws_iam_policy_document" "cross_account_assume_role_mfa" {
  #count = "${local.enabled && local.require_mfa ? 1 : 0}"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    principals {
      type        = "AWS"
      identifiers = ["${var.trust_account_ids}"]
    }
  }
}
