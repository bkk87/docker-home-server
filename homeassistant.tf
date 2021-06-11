# data "docker_registry_image" "homeassistant" {
#   name = "homeassistant/home-assistant:stable"
# }
# resource "docker_image" "homeassistant" {
#   name         = data.docker_registry_image.homeassistant.name
#   keep_locally = true
# }

# resource "docker_volume" "homeassistant_data" {
#   name   = "homeassistant_data"
#   driver = "local"
# }

# resource "docker_container" "homeassistant" {
#   name     = "homeassistant"
#   image    = docker_image.homeassistant.name
#   memory   = var.homeassistant_container_memory_limit
#   restart  = "unless-stopped"
#   must_run = false
#   start    = true
#   mounts {
#     target    = "/etc/localtime"
#     source    = "/etc/localtime"
#     type      = "bind"
#     read_only = true
#   }
#   mounts {
#     target = "/config"
#     type   = "volume"
#     source = docker_volume.homeassistant_data.name
#   }

#   network_mode = "host"

# }

