# provider

variable "docker_connect_uri" {
  default     = "ssh://pi"
  description = "connect string to the (remote) docker daemon"
}

# pihole

variable "pihole_path_adlists_list" {
  type        = string
  default     = "/home/pi/pihole/adlists.list"
  description = "path to the file which is used as a volume bind"
}

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
  "VIRTUAL_HOST=xxxxxxxxxx.fritz.box"]
  description = "list of pihole ENVs"
}

# prometheus

variable "path_prometheus_yml" {
  type        = string
  default     = "/home/pi/prometheus/prometheus.yml"
  description = "path to the file which is used as a volume bind"
}

# mosquitto

variable "path_mosquitto_conf" {
  type        = string
  default     = "/home/pi/mosquitto/mosquitto.conf"
  description = "path to the file which is used as a volume bind"
}


