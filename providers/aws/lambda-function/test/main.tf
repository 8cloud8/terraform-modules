locals {
  function_name = "demo-lambda"
  description   = "Testing lambda function"
  handler       = "test_lambda.whoami_handler"
  runtime       = "python3.6"
  source_file   = "test_lambda.py"
}

module "test_lambda" {
  #source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/lambda-function?ref=v0.0.3"
  source = "../"

  function_name = "${local.function_name}"
  description   = "${local.description}"
  handler       = "${local.handler}"
  runtime       = "${local.runtime}"
  source_file   = "${local.source_file}"

  # optionals
  version       = "0.0.1"

  # vpc testing
  #vpc_cidr_block  = "172.31.0.0/16"

  # or:
  # spec vpc directly //SubnetIds and SecurityIds must coexist or be both empty list//
  #security_group_ids = [""]    # aws ec2 describe-security-groups
  #subnet_ids = ["vpc-a15145c8"] # aws ec2 describe-subnets | grep SubnetId
}

output "print_aws_cli_usage" {
  value = "aws lambda invoke --invocation-type RequestResponse --function-name ${local.function_name} --log-type Tail - | jq '.LogResult' -r | base64 --decode"
}

output "print_aws_cli_get_function" {
  value = "aws lambda get-function --function-name ${local.function_name}"
}
