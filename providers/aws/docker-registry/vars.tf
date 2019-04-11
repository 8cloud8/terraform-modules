variable "tags" {
  default = {
    tf = "true"
  }
}
variable "region" {}
#variable "secret_key" {}
#variable "access_key" {}
variable "ssh_public_key" {}

variable "instance_type" {
  default = "t2.medium"
}

variable "amis" {
  type        = "map"
  description = "Amazon Linux Image"

  default = {
    "eu-west-2"  = "ami-e7d6c983"
    "eu-west-1"  = "ami-1a962263"
  }
}

variable "dns_name" {
  default = "foo.xip.io"
}
