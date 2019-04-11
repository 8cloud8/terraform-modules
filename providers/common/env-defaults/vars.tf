# -- vars
variable "enabled" {
  type        = "string"
  default     = "true"
  description = "Set to false to prevent the module from creating any resources"
}

variable "environments_map" {
  type = "map"

  default = {
    dev     = "dev"
    trn     = "trn"
    staging = "staging"
    prod    = "prod"
  }
  description = "Environment names used in setup (case sensitive)"
}

variable "environments_size_map" {
  type = "map"

  default = {
    dev     = "small"
    trn     = "medium"
    staging = "large"
    prod    = "xlarge"
  }
}

variable "regions_map" {
  type = "map"

  default = {
    dev     = "eu-west-1"
    trn     = "eu-west-1"
    staging = "eu-west-1"
    prod    = "eu-central-1"
  }
}

