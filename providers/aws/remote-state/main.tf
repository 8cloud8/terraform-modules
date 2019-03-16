resource "random_pet" "bucket" {}

resource "aws_s3_bucket" "remote-state" {
  bucket = "${var.bucket}-${random_pet.bucket.id}"
  acl    = "private"

  versioning {
    enabled = "${var.bucket_versioning}"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = "${var.tags}"
}

resource "aws_dynamodb_table" "remote-state" {
  name           = "${var.dynamodb_table}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = "${var.tags}"
}

output "tf_config" {
  value = <<EOF
terraform {
  backend "s3" {
    bucket         = "${aws_s3_bucket.remote-state.id}"
    key            = "${var.key}"
    region         = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.remote-state.id}"
  }
}
EOF
}
