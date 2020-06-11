variable enabled {
  description = "Set to false to prevent this module from creating any resources"
  type        = bool
  default     = true
}

variable enable_redirect_http_to_https {
  type    = bool
  default = true
}

variable enable_ssl_listener {
  type    = bool
  default = true
}

variable environment {
  description = "Environment name to use, eg. stg"
  type        = string
}

variable fixed_response {
  description = "Map containing fixed response configuration for load balancer."
  type        = map(string)
  default     = {}
}

variable tags {
  type        = map(string)
  description = "Tags"
  default     = {}
}

variable internal {
  type    = bool
  default = false
}

variable access_logs {
  description = "Map containing access logging configuration for load balancer."
  type        = map(string)
  default     = {}
}

variable enable_route_53_wildcard_for_domain {
  type    = bool
  default = true
}

variable enable_deletion_protection {
  type    = bool
  default = false
}

variable zone_id {}
variable vpc_id {}
variable subnets { type = list }
variable domain {}
variable region { default = "eu-west-1" }
variable message_body { default = "" }
