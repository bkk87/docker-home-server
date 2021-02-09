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
resource "random_password" "postgres_password" {
  length  = 20
  special = false
}
resource "random_password" "postgres_nextcloud_password" {
  length  = 20
  special = false
}
output "postgres_password" {
  value = random_password.postgres_password.result
}
output "postgres_nextcloud_password" {
  value = random_password.postgres_nextcloud_password.result
}
resource "docker_container" "postgres" {
  name  = "postgres"
  image = docker_image.postgres.name
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
  ports {
    internal = 5432
    external = 5432
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
  networks_advanced {
    name = docker_network.public_network.name
  }
  ipc_mode = "private"
}

