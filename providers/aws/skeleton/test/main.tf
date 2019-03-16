module "test_skeleton" {
  source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/skeleton?ref=v0.0.3"
}

output "region" {
  value = "${module.test_skeleton.region}"
}
