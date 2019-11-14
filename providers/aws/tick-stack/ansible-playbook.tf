locals {
  user = "ubuntu"
  key  = "~/.ssh/my-aws-key.pub"
}

resource "null_resource" "ansible_deploy_tick_stack" {
  #connection {
  #  host = "${aws_instance.test_box.0.public_ip}"
  #  private_key = "${file("./test_box")}"
  #}

  provisioner "local-exec" {
    # command = "ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.ssh_key_private} playbook.yml"
    command = <<EOF
ANSIBLE_NOCOLOR=true PYTHONUNBUFFERED=1 \
ansible-playbook -vv --connection=local -i '${local.tick_ip}', -e 'ansible_python_interpreter=/usr/bin/python3' playbook.yml \
--extra-vars=ansible_os_family='Debian'\
--extra-vars='user="${local.user}" \
--extra-vars='key="${local.key}"

EOF
  }

  depends_on = [
    module.security_group,
    module.ec2_instance
  ]
}
