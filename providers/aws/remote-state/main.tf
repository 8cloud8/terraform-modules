provider "random" {
  version = ">= 2.0.0"
}

provider "aws" {
  version = ">= 2.1.0"
}

data "aws_region" "current" {}

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
  required_version = ">= 0.11.2"
  backend "s3" {
    bucket         = "${aws_s3_bucket.remote-state.id}"
    key            = "${var.key}"
    region         = "${data.aws_region.current.name}"
    dynamodb_table = "${aws_dynamodb_table.remote-state.id}"
  }
}
EOF
}
