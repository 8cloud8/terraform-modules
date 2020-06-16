# outputs.tf

output "ecs_service_id" {
  value = join("", aws_ecs_service.this.*.id)
}

output "ecs_service_name" {
  value = join("", aws_ecs_service.this.*.name)
}

output "ecs_service_iam_role" {
  value = join("", aws_ecs_service.this.*.iam_role)
}

output "ecs_service_desired_count" {
  value = join("", aws_ecs_service.this.*.desired_count)
}
