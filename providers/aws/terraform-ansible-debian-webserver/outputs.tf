output "public_ip" {
  value = "${local.enabled == "true" ? join("", aws_instance.web.*.public_ip) : ""}"
}

output "ssh_instruction" {
  description = "How to access instance after deployment"
  value =<<-MSG

  eval `ssh-agent`
  ssh-add ${local.public_key}
  ssh ${local.vm_user}@${join("", aws_instance.web.*.public_ip)}
  MSG
}
