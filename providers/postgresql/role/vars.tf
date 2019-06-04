variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "create_role" {
  description = "If this module should be creating postgres role."
  default     = "true"
}

variable "role_password" {
  description = "Left empty to autogenerate"
  default  = ""
}

variable "role_name" {
  description = "Left empty to autogenerate"
  default  = ""
}

variable "name" {
  description = "Postgresql database name. Default empty to autogenerate"
  default  = ""
}

variable "owner" {
  description = "PostgreSQL owner. Default emty to autogenerate"
  default     = ""
}

variable "template" {
  default = "template0"
}

variable "encoding" {
  default = "UTF8"
}

variable "lc_collate" {
  default = "C"
}

variable "lc_ctype" {
  default = "C"
}

variable "tablespace_name" {
  default = "pg_default"
}

variable "connection_limit" {
  default = -1
}

variable "is_template" {
  default = false
}
