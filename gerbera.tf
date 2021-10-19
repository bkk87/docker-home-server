data "docker_registry_image" "gerbera" {
  name = "gerbera/gerbera:latest"
}
resource "docker_image" "gerbera" {
  name         = data.docker_registry_image.gerbera.name
  keep_locally = true
}

# resource "docker_volume" "gerbera" {
#   name   = "gerbera_data"
#   driver = "local"
# }

resource "docker_container" "gerbera" {
  name     = "gerbera"
  image    = docker_image.gerbera.name
  memory   = var.gerbera_container_memory_limit
  restart  = "unless-stopped"
  must_run = false
  start    = true
  #   mounts {
  #     target    = "/var/run/gerbera/config.xml"
  #     source    = "/home/pi/gerbera/config.xml"
  #     type      = "bind"
  #     read_only = true
  #   }
  #   mounts {
  #     target = "/content"
  #     type   = "volume"
  #     source = docker_volume.nextcloud_data.name
  #     read_only = true
  #   }
  #   mounts {
  #     target = "/var/run/gerbera"
  #     type   = "volume"
  #     source = docker_volume.gerbera.name
  #   }

  network_mode = "host"
}

