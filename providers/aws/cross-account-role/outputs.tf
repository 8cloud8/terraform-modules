output "arn" {
  value = "${join("", aws_iam_role.cross_account_assume_role.*.arn)}"
}

output "name" {
  value = "${join("", aws_iam_role.cross_account_assume_role.*.name)}"
}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

/*
output "sample_usage" {
  value = <<EOF
data "aws_iam_policy_document" "cross_account_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::333333333333:user/MyUser"]
    }
    resource = ["arn:aws:iam::111111111111:role/CrossAccountDeveloper"]
    actions = ["sts:AssumeRole"]
  }
}
EOF
}
*/
