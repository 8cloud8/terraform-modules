data "terraform_remote_state" "workspace" {
  backend = "local"
  #backend = "s3"
  workspace = "${local.environment}"
}

output "workspace_id" {
 value = "${data.terraform_remote_state.workspace.id}"
}
