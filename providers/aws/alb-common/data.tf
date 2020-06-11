data aws_acm_certificate "this" {
  count       = local.enable_ssl_listener ? 1 : 0
  domain      = format("%s.%s", "*", local.domain)
  statuses    = ["ISSUED"]
  most_recent = true
}
