terraform {
  required_version = ">= 0.12.12"
}

provider "aws" {
  version = ">= 2.33.0"
  region = "eu-west-1"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
}


locals {
  region     = "${data.aws_region.current.name}"
  account_id = "${data.aws_caller_identity.current.account_id}"
}
