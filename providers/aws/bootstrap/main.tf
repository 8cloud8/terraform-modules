resource "random_pet" "bucket" {}

resource "aws_s3_bucket" "terraform" {
  bucket = "${var.bucket}-${random_pet.bucket.id}"
  acl    = "private"

  versioning {
    enabled = "${var.bucket_versioning}"
  }
  tags  = "${var.tags}"
}

resource "aws_dynamodb_table" "terraform" {
  name           = "${var.dynamodb_table}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags  = "${var.tags}"
}
