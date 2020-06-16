data aws_iam_policy_document "ecs_task_execution_role" {
  count = local.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource aws_iam_role "ecs_task_execution_role" {
  count              = local.enabled ? 1 : 0
  name               = format("%s-EcsTaskExecutionRole", local.name)
  assume_role_policy = join("", data.aws_iam_policy_document.ecs_task_execution_role.*.json)
}

resource aws_iam_role_policy_attachment "ecs_task_execution_role" {
  count      = local.enabled ? 1 : 0
  role       = join("", aws_iam_role.ecs_task_execution_role.*.name)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

###
/*

data "aws_iam_policy_document" "task_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}
resource aws_iam_role "ecs_service" {
  count = local.enabled ? 1 : 0
  name  = format("%s-EcsServiceRole", local.name)

  assume_role_policy = data.aws_iam_policy_document.task_role_policy.json
}


resource "aws_iam_role_policy" "ecs_service" {
  count = local.enabled ? 1 : 0
  name  = format("%s-RolePolicy", local.name)
  role  = join("", aws_iam_role.ecs_service.*.name)

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
*/
