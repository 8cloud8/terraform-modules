data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "archive_file" "lambda_archive" {
  type        = "${var.type}"
  source_file = "${var.source_file}"
  output_path = "/tmp/${var.function_name}.${var.type}"
}

locals {
  region = "${data.aws_region.current.name}"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "${format("%s-%s", var.function_name, lower(var.environment))}"
  description      = "${var.description}"
  filename         = "${data.archive_file.lambda_archive.output_path}"
  source_code_hash = "${data.archive_file.lambda_archive.output_base64sha256}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  publish          = "${var.publish}"
  timeout          = "${var.timeout}"

  role = "${signum(length(var.role_arn)) == 1 ? 
                                  var.role_arn : 
                                  format("arn:aws:iam::%s:role/lambda/%s-%s",
                                  data.aws_caller_identity.current.account_id,
                                  var.role_name,
                                  lower(var.environment))}"

  environment {
    variables = "${merge(var.variables, map(
                     "ENVIRONMENT", lower(var.environment),
                      "REGION", data.aws_region.current.name,
                      "ACCOUNT_ID", data.aws_caller_identity.current.account_id))}"
  }

  tags = "${merge(var.tags, map(
            "Environment", lower(var.environment)))}"

  tracing_config {
    mode = "${var.tracing_mode}"
  }
}

output "qualified_arn" {
  value = "${aws_lambda_function.lambda.qualified_arn}"
}
