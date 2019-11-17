variable "tags" {
  default = {
    terraform = "true"
  }
}

variable "image_name" {
}

variable "ecs_key_pair_name" {
  default = ""
}

variable "service_name" {
}

variable "instance_type" {
  default = "t3.micro"
}

variable "container_port" {
  default = 8080
}

variable "memory_reservation" {
  default = 64
}

# asg
variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 1
}

variable "desired_capacity" {
  default = 1
}

# https://www.terraform.io/docs/providers/aws/r/codepipeline.html
variable "github_token" {
}

variable "github_owner" {
}

variable "github_repo" {
}

variable "github_branch" {
  default = "master"
}
