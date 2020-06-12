terraform {
  required_version = ">= 0.12"
}

provider "null" {
  version = "~> 2.1"
}

variable key_name {}

resource null_resource "generate-ssh-key" {
  triggers = {
    build_number = uuid()
  }

  provisioner "local-exec" {
    command = "yes y | ssh-keygen -b 4096 -t rsa -C '${var.key_name}' -N '' -f ${var.key_name}"
  }
}

output build_number {
  value = null_resource.generate-ssh-key.triggers.build_number
}
