terraform {
  required_version = ">= 0.12.25"
}

provider "aws" {
  version = ">= 2.47.0"
  region  = local.region
}

locals {
  region                = var.region
  environment           = var.environment
  name                  = format("%s-%s", var.name, local.environment)
  ecs_cluster_id        = var.ecs_cluster_id
  sg_lb_id              = var.sg_lb_id
  vpc_id                = var.vpc_id
  subnets               = var.subnets
  cpu                   = var.container_cpu
  memory                = var.container_memory
  container_definitions = var.container_definitions
  desired_count         = var.desired_count
  container_name        = var.name
  container_port        = var.port
  assign_public_ip      = false
  #target_group_arn      = length(var.target_group_arn) > 0 ? var.target_group_arn : join("", aws_alb_target_group.this.*.arn)

  tags = merge(var.tags, {
    Environment = local.environment
    Terraform   = "true"
  })

  # Feature toggles:
  enabled = var.enabled ? true : false
}
