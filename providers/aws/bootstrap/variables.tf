variable "bucket" {
  description = "AWS S3 Bucket name for Terraform state"
  default     = "tfstate"
}

variable "bucket_versioning" {
  description = "AWS S3 Bucket versioning"
  default     = "true"
}

variable "dynamodb_table" {
  description = "AWS DynamoDB table name for state locking"
  default     = "tfstate"
}

variable "key" {
  default = "terraform.tfstate"
}

