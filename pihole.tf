# data "docker_registry_image" "pihole" {
#   name = "pihole/pihole:latest"
# }
# resource "docker_image" "pihole" {
#   name         = data.docker_registry_image.pihole.name
#   keep_locally = true
# }

# resource "random_password" "pihole_password" {
#   length  = 20
#   special = false
# }
# output "pihole_password" {
#   value = random_password.pihole_password.result
# }

# resource "docker_volume" "pihole" {
#   name   = "pihole_data"
#   driver = "local"
# }

# resource "docker_container" "pihole" {
#   name     = "pihole"
#   image    = docker_image.pihole.name
#   memory   = var.pihole_container_memory_limit
#   restart  = "unless-stopped"
#   start    = true
#   dns      = ["1.1.1.1", "127.0.0.1"]
#   hostname = "raspberrypi"
#   env = concat(
#     var.pihole_env_list,
#     ["WEBPASSWORD=${random_password.pihole_password.result}"]
#   )

#   healthcheck {
#     interval     = "0s"
#     retries      = 0
#     start_period = "0s"
#     test = [
#       "CMD-SHELL",
#       "dig +norecurse +retry=0 @127.0.0.1 pi.hole || exit 1",
#     ]
#     timeout = "0s"

#   }
#   mounts {
#     target    = "/etc/pihole/"
#     source    = docker_volume.pihole.name
#     type      = "volume"
#     read_only = false
#   }

#   ports {
#     internal = 53
#     external = 53
#     ip       = "0.0.0.0"
#     protocol = "tcp"
#   }
#   ports {
#     internal = 53
#     external = 53
#     ip       = "0.0.0.0"
#     protocol = "udp"
#   }
#   ports {
#     internal = 80
#     external = 8888
#     ip       = "0.0.0.0"
#     protocol = "tcp"
#   }

#   networks_advanced {
#     name = docker_network.private_with_outbound.name
#   }

#   ipc_mode = "private"
# }

