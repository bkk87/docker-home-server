# data "docker_registry_image" "syncthing" {
#   name = "syncthing/syncthing:latest"
# }
# resource "docker_image" "syncthing" {
#   name         = data.docker_registry_image.syncthing.name
#   keep_locally = true
# }

# resource "docker_volume" "syncthing_data" {
#   name   = "syncthing_data"
#   driver = "local"
# }

# resource "docker_volume" "syncthing_data_photos" {
#   name   = "syncthing_data_photos"
#   driver = "local"
# }

# resource "docker_volume" "syncthing_data_videos" {
#   name   = "syncthing_data_videos"
#   driver = "local"
# }

# resource "docker_volume" "syncthing_data_documents" {
#   name   = "syncthing_data_documents"
#   driver = "local"
# }

# resource "docker_volume" "syncthing_data_downloads" {
#   name   = "syncthing_data_downloads"
#   driver = "local"
# }

# resource "docker_volume" "syncthing_data_git" {
#   name   = "syncthing_data_git"
#   driver = "local"
# }
# resource "docker_volume" "syncthing_data_music" {
#   name   = "syncthing_data_music"
#   driver = "local"
# }

# resource "docker_container" "syncthing" {
#   name    = "syncthing"
#   image   = docker_image.syncthing.name
#   memory  = var.syncthing_container_memory_limit
#   restart = "unless-stopped"
#   start   = true
#   env     = ["STGUIADDRESS=0.0.0.0:8384"]
#   mounts {
#     target = "/var/syncthing"
#     type   = "volume"
#     source = docker_volume.syncthing_data.name
#   }
#   mounts {
#     target = "/var/syncthing/Photos"
#     type   = "volume"
#     source = docker_volume.syncthing_data_photos.name
#   }
#   mounts {
#     target = "/var/syncthing/Videos"
#     type   = "volume"
#     source = docker_volume.syncthing_data_videos.name
#   }
#   mounts {
#     target = "/var/syncthing/Downloads"
#     type   = "volume"
#     source = docker_volume.syncthing_data_downloads.name
#   }
#   mounts {
#     target = "/var/syncthing/Documents"
#     type   = "volume"
#     source = docker_volume.syncthing_data_documents.name
#   }
#   mounts {
#     target = "/var/syncthing/git"
#     type   = "volume"
#     source = docker_volume.syncthing_data_git.name
#   }
#   mounts {
#     target = "/var/syncthing/Music"
#     type   = "volume"
#     source = docker_volume.syncthing_data_music.name
#   }

#   network_mode = "host"

#   healthcheck {
#     interval     = "1m0s"
#     retries      = 0
#     start_period = "0s"
#     test = [
#       "CMD-SHELL",
#       "nc -z 127.0.0.1 8384 || exit 1",
#     ]
#     timeout = "10s"
#   }
# }

