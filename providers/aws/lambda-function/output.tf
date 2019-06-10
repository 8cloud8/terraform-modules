output "arn" {
  value = "${local.enabled == "true" ? join("", aws_lambda_function.lambda.*.arn) : ""}"
}

output "qualified_arn" {
  value = "${local.enabled == "true" ? join("", aws_lambda_function.lambda.*.qualified_arn) : ""}"
}

output "version" {
  value = "${local.enabled == "true" ? join("", aws_lambda_function.lambda.*.version) : ""}"
}

output "print_aws_cli_usage" {
  value = "${local.enabled == "true" ? format("aws lambda invoke --invocation-type RequestResponse --function-name %s --log-type Tail - | jq '.LogResult' -r | base64 --decode", local.function_name) : ""}"
}

output "print_aws_cli_get_function" {
  value = "${local.enabled == "true" ? format("aws lambda get-function --function-name %s", local.function_name) : ""}"
}
