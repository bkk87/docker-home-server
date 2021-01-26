data "docker_registry_image" "traefik" {
  name = "traefik:latest"
}
resource "docker_image" "traefik" {
  name         = data.docker_registry_image.traefik.name
  keep_locally = true
}

resource "docker_volume" "traefik_data" {
  name   = "traefik_data"
  driver = "local"
  driver_opts = {
    "type"   = "tmpfs",
    "device" = "tmpfs",
    "o"      = "size=50m"
  }
}

resource "docker_container" "traefik" {
  name     = "traefik"
  image    = docker_image.traefik.name
  restart  = "unless-stopped"
  must_run = false
  start    = true
  env = ["DUCKDNS_TOKEN=${var.duckdns_domain_token}"]
  command = [
    "--certificatesresolvers.myresolver.acme.email=${var.letsencrypt_email}",
    "--certificatesresolvers.myresolver.acme.storage=/etc/traefik/acme/acme.json",
    "--certificatesresolvers.myresolver.acme.dnschallenge.provider=duckdns",
    "--certificatesresolvers.myresolver.acme.dnschallenge.resolvers=1.1.1.1:53",
    "--providers.docker.exposedByDefault=false",
    "--api=true",
    "--api.dashboard=true",
    "--providers.docker",
    "--providers.docker.network=${docker_network.public_network.name}",
    "--log.level=WARN",
    "--entryPoints.http.address=:80",
    "--entryPoints.https.address=:443"
  ]
  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    type      = "bind"
    read_only = true
  }
  mounts {
    target = "/etc/traefik/acme"
    type   = "volume"
    source = docker_volume.traefik_data.name
  }

  ports {
    internal = 80
    external = 80
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
  ports {
    internal = 443
    external = 443
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  networks_advanced {
    name = docker_network.public_network.name
  }

  ipc_mode = "private"

  labels {
    label = "traefik.enable"
    value = "true"
  }
  labels {
    label = "traefik.http.middlewares.auth.digestauth.users"
    value = var.user_digest_auth
  }
  labels {
    label = "traefik.http.middlewares.ratelimit.ratelimit.average"
    value = "10"
  }
  labels {
    label = "traefik.http.middlewares.ratelimit.ratelimit.burst"
    value = "50"
  }
  labels {
    label = "traefik.http.routers.api.middlewares"
    value = "auth@docker"
  }
  labels {
    label = "traefik.http.routers.api.rule"
    value = "Host(`${var.internal_domain_name}`) && (PathPrefix(`/api`))"
  }
  labels {
    label = "traefik.http.routers.api.service"
    value = "api@internal"
  }
  labels {
    label = "traefik.http.routers.dashboard.middlewares"
    value = "auth@docker"
  }
  labels {
    label = "traefik.http.routers.dashboard.rule"
    value = "Host(`${var.internal_domain_name}`) && (PathPrefix(`/dashboard`))"
  }
  labels {
    label = "traefik.http.routers.dashboard.service"
    value = "api@internal"
  }
}




