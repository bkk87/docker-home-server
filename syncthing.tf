data "docker_registry_image" "syncthing" {
  name = "syncthing/syncthing:latest"
}
resource "docker_image" "syncthing" {
  name         = data.docker_registry_image.syncthing.name
  keep_locally = true
}

resource "docker_volume" "syncthing_data" {
  name   = "syncthing_data"
  driver = "local"
}

resource "docker_container" "syncthing" {
  name    = "syncthing"
  image   = docker_image.syncthing.latest
  restart = "unless-stopped"
  start   = true
  env     = ["STGUIADDRESS=0.0.0.0:8384"]
  mounts {
    target = "/var/syncthing"
    type   = "volume"
    source = docker_volume.syncthing_data.name
  }

  network_mode = "host"

  healthcheck {
    interval     = "1m0s"
    retries      = 0
    start_period = "0s"
    test = [
      "CMD-SHELL",
      "nc -z 127.0.0.1 8384 || exit 1",
    ]
    timeout = "10s"
  }
}

