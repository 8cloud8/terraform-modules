data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "http" "whats-my-ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-stretch-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["379101102735"] # Debian
}
