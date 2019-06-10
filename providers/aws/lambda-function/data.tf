data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "archive_file" "lambda_archive" {
  count       = "${local.enabled == "true" ? 1 : 0}"

  type        = "${var.type}"
  source_file = "${var.source_file}"
  output_path = "/tmp/${var.function_name}.${var.type}"
}

data "aws_vpc" "vpc" {
  count = "${local.vpc_enabled}"

  cidr_block = "${var.vpc_cidr_block}"
}

data "aws_subnet_ids" "subnet" {
  count = "${local.vpc_enabled}"

  vpc_id = "${data.aws_vpc.vpc.id}"
}

data "aws_security_group" "sg" {
  count = "${local.vpc_enabled}"

  vpc_id = "${data.aws_vpc.vpc.id}"
}
