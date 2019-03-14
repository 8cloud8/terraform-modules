module "test" {
  source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/skeleton?ref=v0.0.1"
  region = "eu-west-1"
}

output "region" {
  value = "${module.test.region}"
}
