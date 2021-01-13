# data "docker_registry_image" "node_red" {
#   name = "nodered/node-red:latest"
# }
# resource "docker_image" "node_red" {
#   name         = data.docker_registry_image.node_red.name
#   keep_locally = true
# }

# resource "docker_container" "node_red" {
#   name        = "node_red"
#   image       = docker_image.node_red.latest
#   restart     = "unless-stopped"
#   start       = true
#   user        = "node-red"
#   working_dir = "/usr/src/node-red"
#   env         = ["TZ=Europe/Berlin"]
#   ports {
#     internal = 1880
#     external = 1880
#     ip       = "0.0.0.0"
#     protocol = "tcp"
#   }
#   networks_advanced {
#     name = docker_network.private_network.name
#   }
#   ipc_mode = "private"
# }

