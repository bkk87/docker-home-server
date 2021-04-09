# provider

variable "docker_connect_hostname" {
  default     = "pi"
  description = "hostname of the (remote) docker daemon"
}

# pihole

variable "pihole_env_list" {
  type = list(string)
  default = [
    "ServerIP=xxxxxxxxxx",
    "TZ=Europe/Berlin",
    "IPv6=xxxxxxxxxx",
    "PIHOLE_DNS_=xxxxxxxxxx;xxxxxxxxxx",
    "ServerIPv6=xxxxxxxxxx",
    "REV_SERVER=true",
    "REV_SERVER_DOMAIN=fritz.box",
    "REV_SERVER_TARGET=192.168.178.1",
    "REV_SERVER_CIDR=192.168.178.0/24",
    "VIRTUAL_HOST=xxxxxxxxxx.fritz.box"
  ]
  description = "list of pihole ENVs"
}
variable "pihole_container_memory_limit" {
  type    = number
  default = 512
}

# prometheus

variable "path_prometheus_yml" {
  type        = string
  default     = "/home/pi/prometheus/prometheus.yml"
  description = "path to the file which is used as a volume bind"
}

variable "prometheus_container_memory_limit" {
  type    = number
  default = 128
}

# grafana

variable "grafana_container_memory_limit" {
  type    = number
  default = 128
}

# mosquitto

variable "path_mosquitto_conf" {
  type        = string
  default     = "/home/pi/mosquitto/mosquitto.conf"
  description = "path to the file which is used as a volume bind"
}
variable "mosquitto_container_memory_limit" {
  type    = number
  default = 128
}


# traefik

variable "user_digest_auth" {
  type        = string
  description = "htdigest -c htdigestfile traefik myusername"
}
variable "internal_domain_name" {
  type    = string
  default = "myserver.fritz.box"
}
variable "duckdns_domain_name" {
  type    = string
  default = "myserver.duckdns.org"
}
variable "letsencrypt_email" {
  type    = string
  default = "myemail@domain.com"
}
variable "traefik_container_memory_limit" {
  type    = number
  default = 128
}

# nextcloud

variable "nextcloud_admin_username" {
  type    = string
  default = "admin"
}

variable "nextloud_php_mem_limit" {
  type    = string
  default = "512M"
}

variable "nextloud_php_upload_limit" {
  type    = string
  default = "20G"
}

variable "nextloud_container_memory_limit" {
  type    = number
  default = 792
}

# postgres

variable "postgres_container_memory_limit" {
  type    = number
  default = 128
}

# redis

variable "redis_container_memory_limit" {
  type    = number
  default = 32
}

# portainer

variable "portainer_container_memory_limit" {
  type    = number
  default = 128
}

# homeassistant

variable "homeassistant_container_memory_limit" {
  type    = number
  default = 512
}

# syncthing

variable "syncthing_container_memory_limit" {
  type    = number
  default = 512
}

# node_red

variable "node_red_container_memory_limit" {
  type    = number
  default = 512
}

# watchtower

variable "watchtower_container_memory_limit" {
  type    = number
  default = 32
}

