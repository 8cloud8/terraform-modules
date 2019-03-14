variable "name" {
  description = "Name of CF stack to create"
}

variable "parameters" {
  type        = "map"
  description = "CF Parameters which should be used to construct stack"
}

variable "url" {
  description = "URL with CF template to fetch"
}
