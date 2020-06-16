# aws ecs put-account-setting --name serviceLongArnFormat --value enabled

# HACK: https://github.com/hashicorp/terraform/issues/12634#issuecomment-321633155

# Workaround to make sure the target group is created before referencing it
# Do not reference the arn here or it will cause the issue

data aws_lb_target_group "this" {
  count = local.enabled ? 1 : 0
  arn   = join("", aws_alb_target_group.this.*.arn)
}

resource null_resource "alb_exists" {
  triggers = {
    alb_name = var.alb_arn
  }
}

resource aws_alb_target_group "this" {
  count       = local.enabled ? 1 : 0
  name        = format("%s-fargate-tg", local.name)
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.this.id
  target_type = "ip"

  health_check {
    matcher = "200,302" # var.healthcheck_matcher
    /*
    #healthy_threshold   = var.healthy_threshold
    #unhealthy_threshold = var.unhealthy_threshold
    #timeout             = var.healthcheck_timeout
    #protocol            = var.healthcheck_protocol
    #path                = var.healthcheck_path
    #interval            = var.healthcheck_interval
    */
  }
  tags = local.tags

  # HACK:
  depends_on = [null_resource.alb_exists] # aws_alb.<your_name>
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
resource aws_ecs_task_definition "app" {
  count                    = local.enabled ? 1 : 0
  family                   = format("%s-fargate-task", local.name)
  execution_role_arn       = join("", aws_iam_role.ecs_task_execution_role.*.arn)
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.cpu
  memory                   = local.memory
  container_definitions    = local.container_definitions
  tags                     = local.tags

  /*
  dynamic "volume" {
    for_each = length(keys(var.volume)) == 0 ? [] : [var.volume]
    content {
        name      = lookup(var.volume, "name", null)
        host_path = lookup(var.volume, "host_path", null)
        # FIXME:
        #docker_volume_configuration = lookup(var.volume, "docker_volume_configuration", null)
        #efs_volume_configuration = lookup(var.volume, "efs_volume_configuration", null)
    }
  }
  */
}

resource aws_ecs_service "this" {
  count           = local.enabled ? 1 : 0
  name            = format("%s-svc", local.name)
  cluster         = data.aws_ecs_cluster.this.id # local.ecs_cluster_id
  task_definition = join("", aws_ecs_task_definition.app.*.arn)
  desired_count   = local.desired_count
  launch_type     = "FARGATE"
  tags            = local.tags

  #iam_role        = "AWSServiceRoleForECS" # join("", aws_iam_role.ecs_service.*.name)
  #iam_role        = join("", aws_iam_role.ecs_service.*.name)

  network_configuration {
    security_groups  = [join("", aws_security_group.ecs_tasks.*.id)]
    subnets          = local.subnets
    assign_public_ip = local.assign_public_ip
  }

  load_balancer {
    target_group_arn = join("", aws_alb_target_group.this.*.arn) # local.target_group_arn
    container_name   = local.container_name
    container_port   = local.container_port
  }

  #lifecycle {
  #  ignore_changes = [desired_count]
  #}

  depends_on = [aws_alb_target_group.this]
}
