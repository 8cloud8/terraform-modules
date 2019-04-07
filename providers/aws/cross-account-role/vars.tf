variable "extra_tags" {
  description = "Extra tags"
  default     = {}
  type        = "map"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "name" {
  description = "The name of role to create"
}

variable "description" {
  description = "Description of the role"
}

variable "require_mfa" {
  type        = "string"
  default     = "false"
  description = "Require the users to have MFA enabled"
}

variable "trust_account_ids" {
  type = "list"

  description = <<EOF
List of principals (AWS account root user, an IAM user, or a role) to trust to assume this role.
Ex.
["222222222222","arn:aws:iam::333333333333:user/MyUser","arn:aws:iam::444444444444:role/MyRole"]
EOF
}

variable "policy_arns" {
  type = "list"
  default = []
  description = <<EOF
List of ARNs of policies to be associated with the created IAM role.
Ex.:
["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser", "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
Or set to empty list if no polices should be attached: []
EOF
}

variable "policy_json" {
  type        = "string"
  default     = ""
  description = "JSON formatter string. See https://www.terraform.io/docs/providers/aws/guides/iam-policy-documents.html"
}
