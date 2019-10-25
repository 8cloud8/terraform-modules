locals {
  enabled     = var.enabled == "true" ? true : false
  name        = "inlets"
  ssh_keys    = var.ssh_keys
  size        = "s-1vcpu-1gb"
  image       = var.ubuntu
  use_domain  = false
  domain_name = var.domain_name
  record_name = "inlets"
}

provider "digitalocean" {
  # export DIGITALOCEAN_TOKEN="Your API TOKEN"  #
}

resource "digitalocean_droplet" "inlets" {
  count = local.enabled == true ? 1 : 0

  ssh_keys = local.ssh_keys
  image    = local.image

  region    = var.do_ams3
  size      = local.size
  name      = format("%s-%d", local.name, count.index)
  user_data = file("${path.module}/userdata.sh")
  tags      = ["by_terraform"]
}

locals {
  ipv4_address = element(digitalocean_droplet.inlets.*.ipv4_address, 0)
}

variable "domain_name" {}

resource "digitalocean_domain" "inlets" {
  count      = local.enabled == true && local.use_domain == true ? 1 : 0
  name       = local.domain_name
  ip_address = local.ipv4_address
}

resource "digitalocean_record" "inlets" {
  count  = local.enabled == true && local.use_domain == true ? 1 : 0
  domain = "${digitalocean_domain.inlets[count.index].name}"
  type   = "A"
  name   = local.record_name
  value  = local.ipv4_address
}
