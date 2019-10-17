terraform {
  required_version = ">= 0.11.14"
}

variable "enabled" {
  default = "true"
}

variable "playbook_file" {
  default = "playbook.yml"
}

locals {
  enabled       = "${var.enabled == "true" ? true : false}"
  playbook_file = "${var.playbook_file}"
  
  ansible_playbook {
    options    = "-v"
    connection = "local"
    extra_vars = "terraform"
  }
}

resource "null_resource" "ansible_playbook" {
  count = "${local.enabled ? 1 : 0}"

  triggers {
    lastrun = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOF
      ansible-galaxy install -r requirements.yml

      PYTHONUNBUFFERED=1 ansible-playbook -i localhost, \
      --connection=${local.ansible_playbook["connection"]} \
      --extra-vars='foo=${local.ansible_playbook["extra_vars"]}' \
      ${local.ansible_playbook["options"]} \
      ${local.playbook_file}
    EOF
  }
}
