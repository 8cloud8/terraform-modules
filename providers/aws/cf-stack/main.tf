resource "aws_cloudformation_stack" "cf" {
  name               = "${var.name}"
  template_body      = "${chomp(data.http.cf_template_data.body)}"
  on_failure         = "DELETE"
  timeout_in_minutes = "1"
}
