module "test" {
  source = "../"
  region = "eu-west-1"
}

output "region" {
  value = "${module.test.region}"
}
