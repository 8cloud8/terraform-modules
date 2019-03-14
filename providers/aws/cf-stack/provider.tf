provider "http" {
  version = ">= 1.0.1"
}

provider "aws" {
  version = ">= 2.1.0"
  
  region  = "${var.region}"
  profile = "${var.profile}"
}
