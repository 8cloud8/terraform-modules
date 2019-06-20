variable "extra_tags" {
  description = "Extra tags"
  default     = {}
  type        = "map"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "versioned" {
  description = "If S3 obj versioning should be enabled"
  default     = "true"
}

variable "force_destroy" {
  description = "If objects should be delete from bucket so bucket can be destroyed"
  default     = false
}

variable "bucket" {
  description = "The name of the s3 bucket to create"
}
