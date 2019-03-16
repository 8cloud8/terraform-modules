variable "tags" {
  default = {
    tf = "true"
  }
}

variable "std" {
  default = {
    tf_version = "0.11.10"
    default    = "dev"
    region     = "eu-central-1"
    profile    = ""
  }
}
