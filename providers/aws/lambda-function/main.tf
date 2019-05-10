terraform {
  required_version = ">= 0.11.12"
}

provider "aws" {
  version = ">= 2.1.0"
}

provider "archive" {
  version = ">= 1.1.0"
}

locals {
  region      = "${data.aws_region.current.name}"
  account_id  = "${data.aws_caller_identity.current.account_id}"

  vpc_enabled = "${length(var.vpc_cidr_block) > 0 && length(var.security_group_ids) == 0 && length(var.subnet_ids) == 0 ? 1 : 0}"

  security_group_ids = ["${coalescelist(var.security_group_ids, data.aws_security_group.lambda_security_groups.*.id)}"]
  subnet_ids         = ["${coalescelist(var.subnet_ids, data.aws_subnet.lambda_subnets.*.id)}"]

  commons = {
    version = "${coalesce(var.version, "default")}"
  }
}

resource "aws_lambda_function" "lambda" {
  function_name    = "${format("%s", var.function_name)}"
  description      = "${var.description}"
  filename         = "${data.archive_file.lambda_archive.output_path}"
  source_code_hash = "${data.archive_file.lambda_archive.output_base64sha256}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  publish          = "${var.publish}"
  timeout          = "${var.timeout}"
  role             = "${aws_iam_role.iam.arn}"

  vpc_config {
    subnet_ids         = ["${local.subnet_ids}"]
    security_group_ids = ["${local.security_group_ids}"]
  }

  environment {
    variables = "${merge(var.variables, map(
                      "REGION", local.region,
                      "ACCOUNT_ID", local.account_id,
                      "VERSION", local.commons["version"]))}"
  }

  tags = "${merge(var.tags, map(
            "version", local.commons["version"]))}"

  tracing_config {
    mode = "${var.tracing_mode}"
  }
}
