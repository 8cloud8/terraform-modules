variable "tags" {
  default = {
    tf = "true"
  }
}

variable "environment" {
  default = "dev"
}

variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "profile" {
  description = "AWS profile"
  default     = ""
}
