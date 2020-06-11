terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

locals {
  tags = merge(var.tags,
    {
      Terraform = "true"
  })
}

resource "aws_key_pair" "this" {
  count = var.create_key_pair ? 1 : 0

  key_name   = var.key_name
  public_key = var.public_key
  tags       = local.tags
}

output "key_name" {
  description = "The key pair name."
  value       = element(concat(aws_key_pair.this.*.key_name, list("")), 0)
}

output "key_pair_fingerprint" {
  description = "The MD5 public key fingerprint as specified in section 4 of RFC 4716."
  value       = element(concat(aws_key_pair.this.*.fingerprint, list("")), 0)
}
