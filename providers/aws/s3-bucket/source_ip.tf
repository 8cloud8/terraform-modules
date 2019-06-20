variable "source_ips" {
  description = "If populated, list of source IPs allowed to access s3 bucket objects from this bucket (default: empty list)"
  default     = []
  type        = "list"
}

data "aws_iam_policy_document" "enforce_source_ips_policy" {
  count = "${length(compact(var.source_ips)) == 0 ? 0 : 1}"

  statement {
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    condition {
      test     = "Bool"
      values   = ["${var.source_ips}"]
      variable = "aws:SourceIp"
    }
  }
}

resource "aws_s3_bucket_policy" "ip_source_ip_policy" {
  count = "${length(compact(var.source_ips)) == 0 ? 0 : 1}"

  bucket = "${aws_s3_bucket.bucket.id}"
  policy = "${data.aws_iam_policy_document.enforce_source_ips_policy.json}"
}
