output alb_url {
  value = join("", aws_lb.this.*.dns_name)
}

output alb_arn {
  value = join("", aws_lb.this.*.arn)
}

output http_listner_arn {
  value = join("", coalescelist(aws_lb_listener.http_alb_listener.*.arn, aws_lb_listener.fixed_response.*.arn, ["undefined"]))
}

output https_listner_arn {
  value = join("", aws_lb_listener.https_alb_listener.*.arn)
}

output route53_fqdn {
  value = join("", aws_route53_record.this_route53_wildcard.*.fqdn)
}

output sg_id {
  description = "The ID of the security group"
  value       = join("", aws_security_group.this.*.id)
}
