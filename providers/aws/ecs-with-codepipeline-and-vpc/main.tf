terraform {
  required_version = ">= 0.12.12"
}

provider "aws" {
  version = ">= 2.33.0"
}

locals {
  region     = "${data.aws_region.current.name}"
  account_id = "${data.aws_caller_identity.current.account_id}"
}
