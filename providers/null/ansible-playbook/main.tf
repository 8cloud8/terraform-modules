terraform {
  required_version = ">= 0.11.11"
}

variable "enabled" {
  default = "true"
}

variable "playbook_file" {
  default = "playbook.yml"
}

locals {
  enabled = "${var.enabled == "true" ? true : false}"
  playbook_file = "${var.playbook_file}"

  ansible_playbook {
    extra_vars = ""
    options    = "-v"
    connection = "local"
  }
}

resource "null_resource" "ansible_playbook" {
  count = "${local.enabled ? 1 : 0}"

  triggers {
    lastrun = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOF
    ANSIBLE_NOCOLOR=true PYTHONUNBUFFERED=1 ansible-playbook \
    --connection=${local.ansible_playbook["connection"]} \
    ${local.ansible_playbook["options"]} \
    --extra-vars='${local.ansible_playbook["extra_vars"]}' \
    ${local.playbook_file}
  EOF
  }
}
