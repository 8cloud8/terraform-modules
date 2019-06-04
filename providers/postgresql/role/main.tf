terraform {
  required_version = ">= 0.11.11"

  #backend "local" {}
}

locals {
  docker_pg_host            = "0.0.0.0"
  docker_pg_port            = "5432"
  docker_pg_database        = "postgres"
  docker_pg_username        = "admin"
  docker_pg_password        = "admin123456"
  docker_pg_ssl_mode        = "disable"
  docker_pg_connect_timeout = "15"
  docker_superuser          = false
}

provider "postgresql" {
  host            = "${coalesce(var.host, local.docker_pg_host)}"
  port            = "${coalesce(var.port, local.docker_pg_port)}"
  database        = "${coalesce(var.database, local.docker_pg_database)}"
  username        = "${coalesce(var.username, local.docker_pg_username)}"
  password        = "${coalesce(var.password, local.docker_pg_password)}"
  sslmode         = "${coalesce(var.sslmode, local.docker_pg_ssl_mode)}"
  connect_timeout = "${coalesce(var.connect_timeout,local.docker_pg_connect_timeout)}"
  superuser       = "${coalesce(var.superuser, local.docker_superuser)}"
}

# see the other .tf files for all the details..
