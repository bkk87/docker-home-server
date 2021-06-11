# data "docker_registry_image" "whoami" {
#   name = "containous/whoami:latest"
# }
# resource "docker_image" "whoami" {
#   name         = data.docker_registry_image.whoami.name
#   keep_locally = true
# }

# resource "docker_container" "whoami" {
#   name    = "whoami"
#   image   = docker_image.whoami.name
#   restart = "unless-stopped"
#   start   = true
#   #   ports {
#   #     internal = 80
#   #     external = 82
#   #     ip       = "0.0.0.0"
#   #     protocol = "tcp"
#   #   }
#   networks_advanced {
#     name = docker_network.private_with_outbound.name
#   }
#   ipc_mode = "private"
# }



