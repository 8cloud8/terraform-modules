variable "enabled" {
  type        = "string"
  default     = "true"
  description = "Set to false to prevent the module from creating any resources"
}

variable "tags" {
  default = {
    tf = "true"
  }
}

variable "function_name" {
  description = "A unique name for your Lambda Function"
}

variable "description" {
  description = "Description of the Lambda function"
}

variable "role_arn" {
  description = "ARN of IAM role for the Lambda function"
  default     = ""
}

variable "handler" {
  description = "The handler to call, see http://docs.aws.amazon.com/cli/latest/reference/lambda/create-function.html for format"
}

variable "runtime" {
  description = "Which runtime to use, see https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
}

variable "memory_size" {
  description = "Memory size for the Lambda. The value must be a multiple of 64 MB."
  default     = "128"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default     = "3"
}

variable "variables" {
  type        = "map"
  description = "Map with environment variables for the Lambda function"
  default     = {}
}

variable "tracing_mode" {
  default = "PassThrough"

  description = <<EOF
Can be either PassThrough or Active.
If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with sampled=1.
If Active, Lambda will respect any tracing header it receives from an upstream service.
If no tracing header is received, Lambda will call X-Ray for a tracing decision.
EOF
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version"
  default     = "false"
}

variable "source_file" {
  description = "Source file with lambda function"
}

variable "type" {
  description = "The type of archive to generate. NOTE: zip is supported."
  default     = "zip"
}

# http://docs.aws.amazon.com/lambda/latest/dg/vpc.html
variable "vpc_cidr_block" {
  description = "CIDR block of VPC, used to find the VPC id"
  default = ""
}

variable "security_group_ids" {
 type = "list"
 default = []
}

variable "subnet_ids" {
  type= "list"
  default = []
}
