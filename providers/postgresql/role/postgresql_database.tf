locals {
  enabled          = "${var.enabled == "true" ? 1 : 0 }"
  name             = "${coalesce(var.name,join("",  random_pet.db_name.*.id))}"
  owner            = "${coalesce(var.owner,join("", postgresql_role.role.*.name))}"
  template         = "${var.template}"
  encoding         = "${var.encoding}"
  lc_collate       = "${var.lc_collate}"
  lc_ctype         = "${var.lc_ctype}"
  tablespace_name  = "${var.tablespace_name}"
  connection_limit = "${var.connection_limit}"
  is_template      = "${var.is_template}"
}

resource "random_pet" "db_name" {
  count     = "${local.enabled}"
  separator = ""
}

resource "postgresql_database" "database" {
  count            = "${local.enabled}"
  name             = "${local.name}"
  owner            = "${local.owner}"
  template         = "${local.template}"
  encoding         = "${local.encoding}"
  lc_collate       = "${local.lc_collate}"
  lc_ctype         = "${local.lc_ctype}"
  tablespace_name  = "${local.tablespace_name}"
  connection_limit = "${local.connection_limit}"
  is_template      = "${local.is_template}"

  /*
  lifecycle {
    ignore_changes = [
      "template",
      "encoding",
      "lc_collate",
      "lc_ctype",
      "tablespace_name",
    ]
  }
  */
}

locals {
  db_name = "${join("", postgresql_database.database.*.name)}"
  db_id   = "${join("", postgresql_database.database.*.id)}"
}

output "id" {
  value = "${local.db_id}"
}

output "name" {
  value = "${local.db_name}"
}
