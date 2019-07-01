terraform {
  required_version = ">= 0.11.12"
}

provider "aws" {
  version = ">= 2.17.0"
}

locals {
  enabled            = "${var.enabled == "true" ? true : false}"
  name               = "tf-ansible-webserver"

  region             = "${data.aws_region.current.name}"
  account_id         = "${data.aws_caller_identity.current.account_id}"
  external-cidr      = "${chomp(data.http.whats-my-ip.body)}/32"
  tags               = "${var.tags}"

  vm_user            = "admin"
  instance_type      = "t2.micro"
  key_name           = "${local.name}"
  public_key         = "${"~/.ssh/id_rsa.pub"}"
  private_key        = "${"~/.ssh/id_rsa"}"
}
