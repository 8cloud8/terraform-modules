module "test_skeleton" {
  source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/skeleton?ref=master"
}

output "region" {
  value = "${module.test_skeleton.region}"
}
