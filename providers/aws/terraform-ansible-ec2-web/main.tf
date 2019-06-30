terraform {
  required_version = ">= 0.11.12"
}

provider "aws" {
  version = ">= 2.17.0"
}

locals {
  enabled            = "${var.enabled == "true" ? true : false}"
  name               = "terraform-ansible-ec2-web"

  region             = "${data.aws_region.current.name}"
  account_id         = "${data.aws_caller_identity.current.account_id}"
  tags               = "${var.tags}"

  commons = {
    tf = "true"
  }
}
