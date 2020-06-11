terraform {
  required_version = ">= 0.12.25"
}

provider "aws" {
  version = ">= 2.47.0"
  region  = local.region
}

locals {
  domain                     = var.domain
  environment                = var.environment
  name                       = format("%s-%s-lb", local.environment, local.internal == true ? "internal" : "internet-facing")
  message_body               = coalesce(var.message_body, jsonencode(map(local.environment, uuid())))
  region                     = var.region
  internal                   = var.internal
  ssl_policy                 = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  vpc_id                     = var.vpc_id
  subnets                    = var.subnets
  zone_id                    = var.zone_id
  enable_deletion_protection = var.enable_deletion_protection

  # Feature toggles:
  enabled                             = var.enabled ? true : false
  enable_route_53_wildcard_for_domain = local.enabled && var.enable_route_53_wildcard_for_domain ? true : false
  enable_fixed_response               = local.enabled && length(var.fixed_response) > 0 ? true : false
  enable_redirect_http_to_https       = local.enabled && local.enable_fixed_response == false && var.enable_redirect_http_to_https ? true : false
  enable_ssl_listener                 = local.enable_redirect_http_to_https && var.enable_ssl_listener ? true : false

  tags = merge(var.tags,
    {
      Environment = local.environment
      Terraform   = "true"
  })
}

resource aws_lb "this" {
  count                      = local.enabled ? 1 : 0
  name                       = local.name
  internal                   = local.internal
  load_balancer_type         = "application"
  security_groups            = [join("", aws_security_group.this.*.id)]
  subnets                    = local.subnets
  enable_deletion_protection = local.enable_deletion_protection

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = lookup(access_logs.value, "enabled", lookup(access_logs.value, "bucket", null) != null)
      bucket  = lookup(access_logs.value, "bucket", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  tags = local.tags
}

resource aws_lb_listener "http_alb_listener" {
  count             = local.enable_redirect_http_to_https ? 1 : 0
  load_balancer_arn = join("", aws_lb.this.*.arn)
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource aws_lb_listener "fixed_response" {
  count             = local.enable_fixed_response ? 1 : 0
  load_balancer_arn = join("", aws_lb.this.*.arn)
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    dynamic "fixed_response" {
      for_each = length(keys(var.fixed_response)) == 0 ? [] : [var.fixed_response]
      content {
        content_type = lookup(fixed_response.value, "content_type", null)
        message_body = lookup(fixed_response.value, "message_body", null)
        status_code  = lookup(fixed_response.value, "status_code", null)
      }
    }
  }
}

resource aws_lb_listener "https_alb_listener" {
  count             = local.enable_ssl_listener ? 1 : 0
  load_balancer_arn = join("", aws_lb.this.*.arn)
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = local.ssl_policy
  certificate_arn   = join("", data.aws_acm_certificate.this.*.arn)

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = local.message_body
      status_code  = "200"
    }
  }
}

resource aws_route53_record "this_route53_wildcard" {
  count   = local.enable_route_53_wildcard_for_domain ? 1 : 0
  zone_id = local.zone_id
  name    = format("*.%s", local.environment)
  type    = "CNAME"
  records = [join("", aws_lb.this.*.dns_name)]
  ttl     = "300"
}
