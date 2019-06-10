resource "aws_iam_role" "iam" {
  count = "${local.enabled == "true" ? 1 : 0}"

  name  = "${format("%sLambdaRole", var.function_name)}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
