locals {
  create_role   = "${var.create_role == "true" ? 1 : 0 }"
  role_name     = "${coalesce(var.role_name, join("",random_pet.role_name.*.id))}"
  role_password = "${coalesce(var.role_password, join("", random_id.role_password.*.b64))}"
}

resource "random_pet" "role_name" {
  count     = "${local.create_role}"
  separator = ""
}

resource "random_id" "role_password" {
  count       = "${local.create_role}"
  byte_length = 10
}

resource "postgresql_role" "role" {
  count                     = "${local.create_role}"
  name                      = "${local.role_name}"
  superuser                 = false
  create_database           = false
  create_role               = false
  inherit                   = false
  login                     = true
  replication               = false
  bypass_row_level_security = false
  connection_limit          = -1
  encrypted_password        = true
  password                  = "${local.role_password}"
  skip_drop_role            = false
  skip_reassign_owned       = false
  valid_until               = "infinity"
}

/*
resource postgresql_grant "readonly_tables" {
  database    = "${postgresql_database.database.name}"
  role        = "${postgresql_role.role.id}"
  schema      = "public"
  object_type = "table"
  privileges  = ["ALL"]
}
*/

output "usage" {
  value = <<EOF

PGHOST=${local.docker_pg_host} PGPORT=${local.docker_pg_port} PGDATABASE=${local.db_name} PGUSER=${local.role_name} PGPASSWORD=${local.role_password} psql
EOF
}
