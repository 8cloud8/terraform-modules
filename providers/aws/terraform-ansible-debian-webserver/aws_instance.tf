resource "aws_instance" "web" {
  count = "${local.enabled == "true" ? 1 : 0}"

  instance_type               = "${local.instance_type}"
  ami                         = "${data.aws_ami.debian.id}"
  key_name                    = "${local.key_name}"
  security_groups             = ["${aws_security_group.web.name}"]
  associate_public_ip_address = "true"
  tags                        = "${local.tags}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -qq install -y python-minimal",
    ]

    connection {
      user        = "${local.vm_user}"
      private_key = "${file(local.private_key)}"
      type        = "ssh"
    }
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/ansible"
    command     = "PYTHONUNBUFFERED=1 ansible-playbook -vv -u ${local.vm_user} --private-key ${local.private_key} playbook.yml -i ${self.public_ip},"
  }

  depends_on = [ "aws_instance.web" ]
}
