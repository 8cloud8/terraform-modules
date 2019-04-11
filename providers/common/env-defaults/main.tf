terraform {
  required_version = ">= 0.11.2"
}

variable "env" {
  description = "env to run"
}

locals {
  default = "dev"
  enabled = "${var.enabled == "true" ? true : false }"

  env     = "${lookup(var.environments_map,      var.env, local.default)}"
  size    = "${lookup(var.environments_size_map, var.env, local.default)}"
  region  = "${lookup(var.regions_map,           var.env, local.default)}"
}

resource "local_file" "grow_to_prod" {
  count    = "${var.enabled == "true" ? 1 : 0}"
  #content  = "env = \"${trimspace(local.env)}\""
  content  = "env = \"prod\""
  filename = "${local.env}.auto.tfvars"
}

##
output "env" {
  value = "${local.env}"
}

output "size" {
  value = "${local.size}"
}

output "region" {
  value = "${local.region}"
}

output "foo" {
  value  = "${var.regions_map[local.env]}"
}
