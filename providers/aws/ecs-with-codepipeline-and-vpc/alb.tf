locals {
  target_groups = ["primary", "secondary"]
  hosts_name    = ["${var.service_name}.*.terraform.io"]
}

resource "aws_security_group" "alb" {
  name   = "${var.service_name}-allow-http"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.service_name, "alb")))}"
}

resource "aws_lb" "this" {
  name               = "${var.service_name}-service-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = "${aws_subnet.public.*.id}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.service_name, "alb")))}"
}

resource "aws_lb_target_group" "this" {
  count = "${length(local.target_groups)}"
  name  = "${var.service_name}-tg-${element(local.target_groups, count.index)}"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.this.id}"
  target_type = "instance"

  health_check {
    path = "/"
  }

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.service_name, "tg")))}"
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = "${aws_lb.this.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.this.0.arn}"
  }
}

#output "lb_dns_name" {
#  value = "${aws_lb_listener.this.dns_name}"
#}

resource "aws_lb_listener_rule" "this" {
  count        = "${length(local.target_groups)}"
  listener_arn = "${aws_lb_listener.this.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.this.*.arn[count.index]}"
  }

  condition {
    field  = "host-header"
    values = "${local.hosts_name}"
  }
}
