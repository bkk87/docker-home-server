data "docker_registry_image" "network_multitool" {
  name = "praqma/network-multitool:latest"
}
resource "docker_image" "network_multitool" {
  name         = data.docker_registry_image.network_multitool.name
  keep_locally = true
}

resource "docker_container" "network_multitool" {
  name    = "network_multitool"
  image   = docker_image.network_multitool.latest
  restart = "unless-stopped"
  start   = true
  networks_advanced {
    name = docker_network.private_network.name
  }
  ipc_mode = "private"
}

