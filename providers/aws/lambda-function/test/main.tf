locals {
  function_name = "demo_lambda"
  description   = "Testing lambda function"
  handler       = "test_lambda.whoami_handler"
  runtime       = "python3.6"
  source_file   = "test_lambda.py"
  environment   = "dev"
}

module "test_lambda" {
  source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/lambda-function?ref=v0.0.3"
  #source = "../"

  function_name = "${local.function_name}"
  description   = "${local.description}"
  handler       = "${local.handler}"
  runtime       = "${local.runtime}"
  source_file   = "${local.source_file}"
  environment   = "dev"
}

output "ex_aws_cli_usage" {
  value = "aws lambda invoke --invocation-type RequestResponse --function-name ${local.function_name}-${local.environment} --log-type Tail - | jq '.LogResult' -r | base64 --decode"
}
