/**

* Note: this module requires that AMI has been build within the region. Please see `/packer` directory.

**/

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS Region, .g. 'eu-west-1'"
}

variable "most_recent" {
  description = "boolean, maps to `most_recent` parameter for `aws_ami` data source"
  default     = true
  #type        = string
}

variable "filter_name_value" {
  description = "string, maps to `values` parameter for filter name `aws_ami` data source"
  type        = string
}

data "aws_ami" "this" {
  most_recent = var.most_recent

  filter {
    name   = "name"
    values = [var.filter_name_value]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
}

output "id" {
  value       = data.aws_ami.this.id
  description = "ID of the AMI"
}
