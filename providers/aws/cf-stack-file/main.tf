/** Creates CF stack from local file of your choice
*/

terraform {
  required_version = ">= 0.11.13"
}

provider "aws" {
  version = ">= 2.3.0"
}

variable "file_name" {}

resource "aws_cloudformation_stack" "cf_url" {
  name               = "${var.name}"
  template_body      = "${file(chomp("${var.file_name}"))}"
  on_failure         = "DELETE"
  timeout_in_minutes = "1"

  capabilities = "${var.capabilities}"
  parameters   = "${var.parameters}"

  tags = "${merge(map(
		"terraform", "true",
    "created", timestamp(),
		"Name", format("%s", var.name)),
		"${var.extra_tags}")
    }"
}

output "id" {
  value = "${aws_cloudformation_stack.cf_url.id}"
}

output "outputs" {
  value = "${aws_cloudformation_stack.cf_url.outputs}"
}
