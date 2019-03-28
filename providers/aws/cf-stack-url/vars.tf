variable "extra_tags" {
  description = "Extra tags"
  default     = {}
  type        = "map"
}

variable "name" {
  description = "Name of CF stack to create"
}

variable "parameters" {
  type        = "map"
  description = "CF Parameters which should be used to construct stack"
}

variable "capabilities" {
  type    = "list"
  default = []
}

variable "url" {
  description = "URL with CF template to fetch"
}
