terraform {
  required_version = ">= 0.11.2"
  #backend "local" {}
}

locals {
  environment = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
  size = "${local.environment == "dev" ? lookup(var.workspace_to_size_map, terraform.workspace, "small") : var.environment_to_size_map[local.environment]}"
}

output "env" {
 value = "${local.environment}"
}

output "size" {
 value = "${local.size}"
}
