resource aws_security_group "ecs_tasks" {
  count = local.enabled ? 1 : 0

  name        = format("%s-fargate-task-sg", local.name)
  description = "Allow traffic into ${local.name} fargate service. Should only come from the ALB"
  vpc_id      = local.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.port
    to_port         = var.port
    security_groups = data.aws_lb.this.security_groups
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}
