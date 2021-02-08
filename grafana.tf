data "docker_registry_image" "grafana" {
  name = "grafana/grafana:latest"
}
resource "docker_image" "grafana" {
  name         = data.docker_registry_image.grafana.name
  keep_locally = true
}

resource "docker_volume" "grafana" {
  name   = "grafana_data"
  driver = "local"
}

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana.name
  env = [
    "GF_PATHS_CONFIG=/etc/grafana/grafana.ini",
    "GF_PATHS_DATA=/var/lib/grafana",
    "GF_PATHS_HOME=/usr/share/grafana",
    "GF_PATHS_LOGS=/var/log/grafana",
    "GF_PATHS_PLUGINS=/var/lib/grafana/plugins",
    "GF_PATHS_PROVISIONING=/etc/grafana/provisioning",
    "GF_AUTH_DISABLE_LOGIN_FORM=true",
    "GF_AUTH_ANONYMOUS_ENABLED=true",
    "GF_AUTH_ANONYMOUS_ORG_NAME=Main Org.",
    "GF_USERS_ALLOW_SIGN_UP=false",
    "GF_AUTH_ANONYMOUS_ORG_ROLE=Admin",
    "GF_INSTALL_PLUGINS=grafana-piechart-panel"
  ]
  restart     = "unless-stopped"
  start       = true
  working_dir = "/usr/share/grafana"
  user        = "472"
  mounts {
    target    = "/var/lib/grafana"
    type      = "volume"
    source    = docker_volume.grafana.name
    read_only = false
  }
  ports {
    internal = 3000
    external = 3000
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
  ipc_mode = "private"
}

