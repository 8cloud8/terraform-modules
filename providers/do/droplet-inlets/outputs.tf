output "public_ip" {
  value = "${digitalocean_droplet.inlets.*.ipv4_address}"
}

output "name" {
  value = "${digitalocean_droplet.inlets.*.name}"
}

output "ssh_login" {
  value = "root@${digitalocean_droplet.inlets.*.ipv4_address}"
}
