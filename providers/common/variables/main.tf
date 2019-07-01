terraform {
  required_version = ">= 0.11.13"
}

locals {
  environment = "${lookup(var.workspace_env_map, terraform.workspace, "dev")}"
}

output "env" {
  value = "${local.environment}"
}
