terraform {
  required_version = ">= 0.11.14"
}

locals {
  enabled = "${var.enabled == "true" ? true : false}"
  name    = "inlets"
}

provider "digitalocean" {
  # You need to set this in your .bashrc  # export DIGITALOCEAN_TOKEN="Your API TOKEN"  #
}

resource "digitalocean_droplet" "inlets" {
  count = "${local.enabled == "true" ? 1 : 0}"

  # Obtain your ssh_key id number via your account. See Document https://developers.digitalocean.com/documentation/v2/#list-all-keys
  # ssh_keys           = [12345678]       # Key example
  image = "ubuntu-18-04-x64"

  region = "${var.do_ams3}"
  size   = "1Gb"
  name   = "${local.name}-${count.index}"

  # user_data        = "${file("${path.module}/user_data.sh")}"

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install curl",
      "curl -sLS https://get.inlets.dev | sudo sh",
      "curl -sLO https://raw.githubusercontent.com/inlets/inlets/master/hack/inlets.service",
      "mv inlets.service /etc/systemd/system/inlets.service",
      "echo AUTHTOKEN=$(head -c 16 /dev/urandom | shasum | cut -d\" \" -f1) > /etc/default/inlets &&",
      "systemctl start inlets &&",
      "systemctl enable inlet",
    ]

    connection {
      type        = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }

    #tags = ["by_terraform"]
  }
}

locals {
  ipv4_address = "${element(digitalocean_droplet.inlets.*.ipv4_address, 0)}"
}

/*
resource "digitalocean_domain" "inlets" {
  name       = "www.inlets.com"
  ip_address = "${local.ipv4_address}"
}

resource "digitalocean_record" "inlets" {
  domain = "${digitalocean_domain.inlets.name}"
  type   = "A"
  name   = "inlets"
  value  = "${local.ipv4_address}"
}
*/
