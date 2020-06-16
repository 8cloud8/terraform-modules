/*
data aws_region "current" {}

data template_file "app" {
  template = file("${path.module}/templates/app.json.tpl")

  vars = {
    name          = var.name
    image         = var.image
    port          = var.port
    cpu           = var.container_cpu
    memory        = var.container_memory
    awslogs-group = format("/ecs/%s", local.name)
    aws_region    = data.aws_region.current.name
  }
}
*/


data aws_ecs_cluster "this" {
  cluster_name = var.ecs_cluster_id
}

data aws_vpc "this" {
  id = var.vpc_id
}

data aws_lb "this" {
  arn = var.alb_arn
}

data aws_lb_listener "https" {
  load_balancer_arn = var.alb_arn
  port              = 443
}

data aws_lb_listener "http" {
  load_balancer_arn = var.alb_arn
  port              = 80
}
