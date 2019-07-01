resource "aws_key_pair" "web" {
  count = "${local.enabled == "true" ? 1 : 0}"

  key_name   = "${local.key_name}"
  public_key = "${file(local.public_key)}"
}
