provider "archive" {
  version = ">= 1.1.0"
}

provider "aws" {
  version = ">= 2.1.0"

  profile = "${var.profile}"
  region  = "${var.region}"
}
