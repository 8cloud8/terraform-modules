provider "random" {
  version = ">= 2.0.0"
}

provider "aws" {
  version = ">= 2.1.0"
  
  profile = "${var.profile}"
  region  = "${var.region}"
}
