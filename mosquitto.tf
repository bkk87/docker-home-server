data "docker_registry_image" "mosquitto" {
  name = "eclipse-mosquitto:latest"
}
resource "docker_image" "mosquitto" {
  name         = data.docker_registry_image.mosquitto.name
  keep_locally = true
}

resource "docker_volume" "mosquitto_data" {
  name   = "mosquitto_data"
  driver = "local"
  driver_opts = {
    "type"   = "tmpfs",
    "device" = "tmpfs",
    "o"      = "size=50m"
  }
}

resource "docker_container" "mosquitto" {
  name     = "mosquitto"
  image    = docker_image.mosquitto.name
  memory   = var.mosquitto_container_memory_limit
  restart  = "unless-stopped"
  must_run = false
  start    = true
  mounts {
    target    = "/mosquitto/config/mosquitto.conf"
    source    = var.path_mosquitto_conf
    type      = "bind"
    read_only = true
  }
  mounts {
    target = "/mosquitto/data"
    type   = "volume"
    source = docker_volume.mosquitto_data.name
  }
  mounts {
    target = "/mosquitto/log"
    type   = "volume"
    source = docker_volume.mosquitto_data.name
  }

  ports {
    internal = 1883
    external = 1883
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  ipc_mode = "private"
}

