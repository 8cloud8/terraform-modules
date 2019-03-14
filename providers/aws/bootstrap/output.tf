output "bucket_name" {
  value = "${aws_s3_bucket.terraform.id}"
}

output "tf_config" {
  value = <<EOF
terraform {
  backend "s3" {
    bucket         = "${aws_s3_bucket.terraform.id}"
    key            = "${var.key}"
    region         = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.terraform.id}"
  }
}
EOF
}
