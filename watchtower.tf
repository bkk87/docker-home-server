data "docker_registry_image" "watchtower" {
  name = "containrrr/watchtower:latest"
}
resource "docker_image" "watchtower" {
  name         = data.docker_registry_image.watchtower.name
  keep_locally = true
}

resource "random_password" "watchtower_token" {
  length  = 20
  special = false
}
output "watchtower_token" {
  value = random_password.watchtower_token.result
}
resource "docker_container" "watchtower" {
  name  = "watchtower"
  image = docker_image.watchtower.name
  env = [
    "WATCHTOWER_CLEANUP=true",
    "WATCHTOWER_POLL_INTERVAL=86400",
    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "WATCHTOWER_HTTP_API_TOKEN=${random_password.watchtower_token.result}",
    "WATCHTOWER_HTTP_API_METRICS=true"
  ]
  restart = "unless-stopped"
  start   = true
  mounts {
    target    = "/etc/timezone"
    source    = "/etc/timezone"
    type      = "bind"
    read_only = true
  }
  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    type      = "bind"
    read_only = false
  }
  ports {
    internal = 8080
    external = 8080
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
  ipc_mode = "private"
  labels {
    label = "com.centurylinklabs.watchtower"
    value = "true"
  }
}

