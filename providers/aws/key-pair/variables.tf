variable "region" {
  description = "AWS Region, eg. 'eu-west-1'"
}

variable tags {
  type        = map(string)
  description = "Tags"
  default     = {}
}

variable "create_key_pair" {
  description = "Controls if key pair should be created"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "The name for the key pair"
  type        = string
  default     = null
}

variable "public_key" {
  description = "The public key material"
  type        = string
}
