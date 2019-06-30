locals {
  vm_user       = "ubuntu"
  instance_type = "t2.micro"
  key_name      = "${local.name}"
  public_key    = "${file("~/.ssh/id_rsa.pub")}"
  #private_key   = "${file("~/.ssh/id_rsa")}"
  private_key   = "${"~/.ssh/id_rsa"}"
}

resource "aws_security_group" "web" {
  count = "${local.enabled == "true" ? 1 : 0}"

  name        = "${local.name}"
  description = "Web security group"
  tags        = "${local.tags}"

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "web" {
  count = "${local.enabled == "true" ? 1 : 0}"

  key_name   = "${local.key_name}"
  public_key = "${local.public_key}"
}

resource "aws_instance" "web" {
  count = "${local.enabled == "true" ? 1 : 0}"

  instance_type               = "${local.instance_type}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  key_name                    = "${local.key_name}"
  security_groups             = ["${aws_security_group.web.name}"]
  associate_public_ip_address = "true"
  tags = "${local.tags}"

  /*
  provisioner "remote-exec" {
    inline = [
      "apt-get update && apt-get -qq install python-minimal -y",
    ]

    connection {
      user        = "${local.vm_user}"
      private_key = "${local.private_key}"
      #host        = "${self.public_ip}"
      type         = "ssh"
    }
  }
  */

  provisioner "local-exec" {
    #environment {  #  PUBLIC_IP  = "${self.public_ip}"  #  PRIVATE_IP = "${self.ipv4_address_private}"  #}

    working_dir = "${path.module}/ansible"
    command     = "PYTHONUNBUFFERED=1 ansible-playbook -vvv -u ${local.vm_user} --private-key ${local.private_key} playbook.yml -i ${self.public_ip},"
  }

  depends_on = [ "aws_instance.web" ]
}
