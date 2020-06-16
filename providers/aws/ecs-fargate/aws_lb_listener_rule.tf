# aws_lb_listener_rule.tf

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-update-rules.html
#
# `aws elbv2 modify-rule --generate-cli-skeleton`
#

variable host_header {
  type = list(string)
}

variable source_ip {
  description = "Optional: list containing source ip allowed to access this site"
  type        = list(string)
  default     = []
}

variable path_pattern {
  description = "Optional: list containing pattern for this site."
  type        = list(string)
  default     = []
}

variable http_request_method {
  description = "Optional: list containing http request method for this site."
  type        = list(string)
  default     = []
}

variable http_header {
  description = "Optional: map containing http header configuration for this site."
  type        = map(string)
  default     = {}

  #type        = list(map(string))
  #default     = []
}

variable query_string {
  description = "Optional: map containing query string configuration for this site."
  type        = map(string)
  default     = {}
}

resource aws_lb_listener_rule "this" {
  count        = local.enabled && length(var.host_header) > 0 ? length(var.host_header) : 0
  listener_arn = data.aws_lb_listener.https.arn
  priority     = null

  action {
    type             = "forward"
    target_group_arn = join("", aws_alb_target_group.this.*.arn)
  }

  # https://www.terraform.io/docs/providers/aws/r/lb_listener_rule.html#condition-blocks
  condition {
    host_header {
      values = [element(var.host_header, count.index)]
    }
  }

  dynamic "condition" {
    for_each = length(var.source_ip) > 0 ? [true] : []
    content {
      source_ip {
        values = var.source_ip
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.path_pattern) > 0 ? [true] : []
    content {
      path_pattern {
        values = var.path_pattern
      }
    }
  }
  dynamic "condition" {
    for_each = length(var.http_request_method) > 0 ? [true] : []
    content {
      http_request_method {
        values = var.http_request_method
      }
    }
  }
  dynamic "condition" {
    for_each = length(keys(var.query_string)) == 0 ? [] : [var.query_string]
    content {
      query_string {
        key   = keys(var.query_string)
        value = values(var.query_string)
      }
    }
  }
  dynamic "condition" {
    for_each = length(keys(var.http_header)) == 0 ? [] : [var.http_header]
    content {
      http_header {
        http_header_name = lookup(var.http_header, "http_header_name", null)
        values           = [lookup(var.http_header, "values", null)]
      }
    }
  }

  depends_on = [aws_alb_target_group.this]
}


output lb_listener_rule_id {
  value = join("", aws_lb_listener_rule.this.*.id)
}

output lb_listener_rule_arn {
  value = join("", aws_lb_listener_rule.this.*.arn)
}

output source_ip {
  value = var.source_ip
}

output host_header {
  value = var.host_header
}

output http_header {
  value = var.http_header
}

output http_request_method {
  value = var.http_request_method
}
