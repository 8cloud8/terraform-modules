module "test" {
  source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/bootstrap?ref=v0.0.1"
  bucket = "demo"
}

output "terraform.tfvars" {
  value = "${module.test.tf_config}"
}
