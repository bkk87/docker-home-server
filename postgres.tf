data "docker_registry_image" "postgres" {
  name = "postgres:11"
}
resource "docker_image" "postgres" {
  name         = data.docker_registry_image.postgres.name
  keep_locally = true
}

resource "docker_volume" "postgres" {
  name   = "postgres_data"
  driver = "local"
}
resource "docker_volume" "postgres_tmp" {
  name   = "postgres_data_tmp"
  driver = "local"
  driver_opts = {
    "type"   = "tmpfs",
    "device" = "tmpfs",
    "o"      = "size=32m"
  }
}

resource "random_password" "postgres_password" {
  length  = 20
  special = false
}
resource "random_password" "postgres_nextcloud_password" {
  length  = 20
  special = false
}
output "postgres_password" {
  value     = random_password.postgres_password.result
  sensitive = true
}
output "postgres_nextcloud_password" {
  value     = random_password.postgres_nextcloud_password.result
  sensitive = true
}

# manually run: 
#CREATE USER nextcloud WITH PASSWORD '<postgres_nextcloud_password>';
#CREATE DATABASE nextcloud TEMPLATE template0 ENCODING 'UNICODE';
#ALTER DATABASE nextcloud OWNER TO nextcloud;
#GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;

# in postgresql.conf set stats_temp_directory = '/var/lib/postgresql/tmp' to reduce disk i/o

resource "docker_container" "postgres" {
  name   = "postgres"
  image  = docker_image.postgres.name
  memory = var.postgres_container_memory_limit
  env = [
    "POSTGRES_PASSWORD=${random_password.postgres_password.result}"
  ]
  restart = "unless-stopped"
  start   = true
  mounts {
    target    = "/var/lib/postgresql/data"
    type      = "volume"
    source    = docker_volume.postgres.name
    read_only = false
  }
  mounts {
    target    = "/var/lib/postgresql/tmp"
    type      = "volume"
    source    = docker_volume.postgres_tmp.name
    read_only = false
  }
  networks_advanced {
    name = docker_network.private_with_outbound.name
  }
  ipc_mode = "private"
}

