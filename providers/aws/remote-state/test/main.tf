module "test" {
  source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/remote-state?ref=v0.0.3"
  bucket = "demo.io"
}

output "terraform.tfvars" {
  value = "${module.test.tf_config}"
}
