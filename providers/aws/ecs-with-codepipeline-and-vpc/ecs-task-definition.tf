locals {
  image_name = var.image_name

  #image_version = "latest"
  #image_name = format("%s/%s:%s", var.github_owner, var.github_repo, local.image_version)
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.service_name}"
  execution_role_arn       = "${aws_iam_role.execution_role.arn}"
  task_role_arn            = "${aws_iam_role.task_role.arn}"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions = templatefile("${path.module}/templates/app.tmpl",
    { service_name       = "${var.service_name}",
      image_name         = "${local.image_name}",
      container_port     = var.container_port,
      memory             = 128,
      memoryReservation  = var.memory_reservation
    }
  )
  tags = "${merge(var.tags, map("Name", format("%s-%s", var.service_name, "ecs-task")))}"
}

output "task_definition_revision" {
  value = "${aws_ecs_task_definition.this.revision}"
}

output "task_definition_arn" {
  value = "${aws_ecs_task_definition.this.arn}"
}

output "task_definition_family" {
  value = "${aws_ecs_task_definition.this.family}"
}
