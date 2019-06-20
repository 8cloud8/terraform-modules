module "test_cf_stack_file" {
  source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/cf-stack-file?ref=master"

  # Source: https://s3.eu-west-1.amazonaws.com/cloudformation-templates-eu-west-1/IAM_Users_Groups_and_Policies.template
  file_name = "IAM_Users_Groups_and_Policies.yaml"

  name = "tf-demo-cf-iam"

  parameters = {
    Password = "VeRryW3akpAss"
  }

  ## Optionals
  extra_tags = {
    "sample" = "true"
  }

  capabilities = ["CAPABILITY_IAM"]
}
