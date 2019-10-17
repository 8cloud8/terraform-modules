terraform {
  required_version = ">= 0.11.14"
}

locals {
  enabled = "${var.enabled == "true" ? true : false}"
  name    = "mywebserver-ex"
}

provider "digitalocean" {
  # You need to set this in your .bashrc  # export DIGITALOCEAN_TOKEN="Your API TOKEN"  #
}

resource "digitalocean_droplet" "mywebserver" {
  count = "${local.enabled == "true" ? 1 : 0}"

  # Obtain your ssh_key id number via your account. See Document https://developers.digitalocean.com/documentation/v2/#list-all-keys
  ssh_keys           = [12345678]       # Key example
  image              = "${var.ubuntu}"
  region             = "${var.do_ams3}"
  size               = "s-1vcpu-1gb"
  private_networking = true
  backups            = true
  ipv6               = true
  name               = "${local.name}"

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
    ]

    connection {
      type        = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
}

/*
resource "digitalocean_domain" "mywebserver" {
  name       = "www.mywebserver.com"
  ip_address = "${digitalocean_droplet.mywebserver.ipv4_address}"
}

resource "digitalocean_record" "mywebserver" {
  domain = "${digitalocean_domain.mywebserver.name}"
  type   = "A"
  name   = "mywebserver"
  value  = "${digitalocean_droplet.mywebserver.ipv4_address}"
}
*/

