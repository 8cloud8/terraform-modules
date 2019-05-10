output "arn" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "qualified_arn" {
  value = "${aws_lambda_function.lambda.qualified_arn}"
}

output "version" {
  value = "${aws_lambda_function.lambda.version}"
}
