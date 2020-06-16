variable enabled {
  description = "Set to false to prevent this module from creating any resources"
  type        = bool
  default     = true
}

variable region { default = "eu-west-1" }

variable tags {
  type        = map(string)
  description = "Optional: tags for the resources"
  default     = {}
}

variable name {
  description = "The name for the Fargate container resouce to be created"
  type        = string
}

variable environment {
  description = "Environment name to use, eg. stg"
  type        = string
}


variable desired_count {
  description = "Number of docker containers to run"
}

variable subnets {
  description = "List of existing VPC subnets where this fargate task should run"
  type        = list(string)
}

variable vpc_id {
  description = "ID of existing VPC"
  type        = string
}

variable ecs_cluster_id {
  description = "The id of existing ecs cluster"
  type        = string
}

variable sg_lb_id {
  description = "SG ID of existing load balancer"
  type        = string
}

variable port {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable container_cpu {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 256
}

variable container_memory {
  description = "Fargate instance memory to provision (in MB)"
  default     = 512
}

variable healthy_threshold {
  type    = number
  default = 3
}

variable unhealthy_threshold {
  type    = number
  default = 2
}

variable healthcheck_timeout {
  type    = number
  default = 3
}

variable healthcheck_protocol {
  type    = string
  default = "HTTP"
}

variable healthcheck_path {
  type    = string
  default = "/"
}

variable healthcheck_interval {
  type    = number
  default = 30
}

variable healthcheck_matcher {
  type    = number
  default = 200
}

variable volume {
  description = "Volume block arguments"
  type        = map(string)
  default     = {}
}

variable alb_arn {
  description = "The Amazon Resource Name (ARN) of the ALB that this ECS Service will use as its load balancer."
}

variable "container_definitions" {
  description = "A default JSON for container definition, see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
  default     = <<-TASK_DEFINITION
  [
    {
        "cpu": 10,
        "environment": [
            {"name": "VARNAME", "value": "VARVAL"}
        ],
        "essential": true,
        "image": "nginx",
        "memory": 128,
        "name": "nginx",
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 80
            }
        ]
    }
  ]
  TASK_DEFINITION
}
