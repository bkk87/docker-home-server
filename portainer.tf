data "docker_registry_image" "portainer" {
  name = "portainer/portainer-ce:latest"
}
resource "docker_image" "portainer" {
  name         = data.docker_registry_image.portainer.name
  keep_locally = true
}

resource "docker_volume" "portainer_data" {
  name   = "portainer_data"
  driver = "local"
}

resource "docker_container" "portainer" {
  name        = "portainer"
  image       = docker_image.portainer.name
  memory      = var.portainer_container_memory_limit
  restart     = "unless-stopped"
  start       = true
  working_dir = "/"
  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    type      = "bind"
    read_only = false
  }
  mounts {
    target = "/data"
    type   = "volume"
    source = docker_volume.portainer_data.name
  }

  ports {
    internal = 9000
    external = 9000
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  networks_advanced {
    name = docker_network.private_with_outbound.name
  }

  ipc_mode = "private"
}

