terraform {
  required_version = ">= 0.11.2"
}

locals {
  env   = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
  size  = "${local.env == "dev" ? lookup(var.workspace_to_size_map, terraform.workspace, "small") : var.environment_to_size_map[local.env]}"
}

/*
usage:
module "dev-env" {
  source      = "git::https://github.com/8cloud8/terraform-modules.git//providers/common/env-defaults?ref=v0.0.4"
  environment = "dev"
  size        = "large"
}

your_module_size = "${module.dev-env.size}"
*/
