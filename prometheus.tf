

data "docker_registry_image" "prometheus" {
  name = "prom/prometheus:latest"
}
resource "docker_image" "prometheus" {
  name         = data.docker_registry_image.prometheus.name
  keep_locally = true
}

resource "docker_volume" "prometheus_data" {
  name   = "prometheus_data"
  driver = "local"
  driver_opts = {
    "type"   = "tmpfs",
    "device" = "tmpfs",
    # default prometheus metrics retention is 15 days 
    # this is enough storage for node_exporter and traefik metrics
    "o" = "size=1024m"
  }
}

resource "docker_container" "prometheus" {
  name        = "prometheus"
  image       = docker_image.prometheus.name
  memory      = var.prometheus_container_memory_limit
  restart     = "unless-stopped"
  start       = true
  user        = "nobody"
  working_dir = "/prometheus"
  mounts {
    target    = "/etc/prometheus/prometheus.yml"
    source    = var.path_prometheus_yml
    type      = "bind"
    read_only = true
  }
  mounts {
    target = "/prometheus"
    type   = "volume"
    source = docker_volume.prometheus_data.name
  }

  ports {
    internal = 9090
    external = 9090
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  networks_advanced {
    name = docker_network.public_network.name
  }
  ipc_mode = "private"

}

