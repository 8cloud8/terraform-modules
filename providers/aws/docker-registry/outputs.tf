output "registry_ip" {
  value = "${aws_eip.default.public_ip}"
}
