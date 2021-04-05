data "docker_registry_image" "redis" {
  name = "redis:buster"
}
resource "docker_image" "redis" {
  name         = data.docker_registry_image.redis.name
  keep_locally = true
}

resource "docker_container" "redis" {
  name    = "redis"
  image   = docker_image.redis.name
  memory = var.redis_container_memory_limit
  restart = "unless-stopped"
  start   = true
  networks_advanced {
    name = docker_network.public_network.name
  }
  ipc_mode = "private"
}

