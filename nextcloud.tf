data "docker_registry_image" "nextcloud" {
  name = "nextcloud:stable"
}
resource "docker_image" "nextcloud" {
  name         = data.docker_registry_image.nextcloud.name
  keep_locally = true
}

resource "docker_volume" "nextcloud_data" {
  name   = "nextcloud_data"
  driver = "local"
}

resource "random_password" "nextcloud_password" {
  length  = 20
  special = false
}
output "nextcloud_password" {
  value = random_password.nextcloud_password.result
}

# recommendation is to not run cron is/as a container but instead add the following lines on your docker host system
# 0 0 * * * docker exec --user www-data nextcloud php occ preview:pre-generate
# */5 * * * * docker exec --user www-data nextcloud php -f /var/www/html/cron.php
#
# resource "docker_container" "nextcloud_cron" {
#   depends_on = [docker_container.nextcloud]
#   name       = "nextcloud-cron"
#   image      = docker_image.nextcloud.name
#   restart    = "unless-stopped"
#   entrypoint = ["/cron.sh"]

#   mounts {
#     target = "/var/www/html"
#     type   = "volume"
#     source = docker_volume.nextcloud_data.name
#   }

#   networks_advanced {
#     name = docker_network.public_network.name
#   }

#   ipc_mode = "private"
# }

resource "docker_container" "nextcloud" {
  depends_on = [docker_container.postgres, docker_container.redis]
  name       = "nextcloud"
  image      = docker_image.nextcloud.name
  restart    = "unless-stopped"
  dns        = ["1.1.1.1"]
  env = [
    "POSTGRES_DB=nextcloud",
    "POSTGRES_USER=nextcloud",
    "POSTGRES_PASSWORD=${random_password.postgres_nextcloud_password.result}",
    "POSTGRES_HOST=postgres",
    "NEXTCLOUD_ADMIN_USER=${var.nextcloud_admin_username}",
    "NEXTCLOUD_ADMIN_PASSWORD=${random_password.nextcloud_password.result}",
    "NEXTCLOUD_TRUSTED_DOMAINS=${var.duckdns_domain_name}",
    "TRUSTED_PROXIES=172.19.0.0/24",
    "PHP_MEMORY_LIMIT=${var.nextloud_mem_limit}",
    "PHP_UPLOAD_LIMIT=${var.nextloud_upload_limit}",
    "REDIS_HOST=redis"
  ]

  mounts {
    target = "/var/www/html"
    type   = "volume"
    source = docker_volume.nextcloud_data.name
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
    label = "traefik.http.services.nextcloud.loadbalancer.server.port"
    value = "80"
  }
  labels {
    label = "traefik.http.routers.web-secure.entrypoints"
    value = "https"
  }
  labels {
    label = "traefik.http.routers.web-secure.middlewares"
    value = "ratelimit@docker,nc-rep@docker,nc-header@docker" #,auth@docker"
  }
  labels {
    label = "traefik.http.routers.web-secure.rule"
    value = "Host(`${var.duckdns_domain_name}`)"
  }
  labels {
    label = "traefik.http.routers.web-secure.service"
    value = "nextcloud@docker"
  }
  labels {
    label = "traefik.http.routers.web-secure.tls"
    value = "true"
  }
  labels {
    label = "traefik.http.routers.web-secure.tls.certresolver"
    value = "myresolver"
  }
  labels {
    label = "traefik.http.routers.web.entrypoints"
    value = "http"
  }
  labels {
    label = "traefik.http.routers.web.middlewares"
    value = "https-redirect"
  }
  labels {
    label = "traefik.http.routers.web.rule"
    value = "Host(`${var.duckdns_domain_name}`)"
  }
  labels {
    label = "traefik.http.middlewares.https-redirect.redirectscheme.scheme"
    value = "https"
  }
  labels {
    label = "traefik.http.middlewares.nc-rep.redirectregex.regex"
    value = "https://(.*)/.well-known/(card|cal)dav"
  }
  labels {
    label = "traefik.http.middlewares.nc-rep.redirectregex.replacement"
    value = "https://$1/remote.php/dav/"
  }
  labels {
    label = "traefik.http.middlewares.nc-rep.redirectregex.permanent"
    value = "true"
  }
  labels {
    label = "traefik.http.middlewares.nc-header.headers.customFrameOptionsValue"
    value = "SAMEORIGIN"
  }
}

