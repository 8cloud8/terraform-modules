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
  # ssh_keys           = [25624561]       # Key example
  image = "ubuntu-18-04-x64"

  region    = "${var.do_ams3}"
  size      = "s-1vcpu-1gb"
  name      = "${local.name}-${count.index}"
  user_data = "${file("${path.module}/userdata.sh")}"
  tags      = ["by_terraform"]
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
