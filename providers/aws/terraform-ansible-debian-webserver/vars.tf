variable "enabled" {
  type        = "string"
  default     = "true"
  description = "Set to false to prevent the module from creating any resources"
}

variable "tags" {
  default = {
    tf = "true"
  }
}
