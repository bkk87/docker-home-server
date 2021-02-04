# Set the required provider and versions
terraform {
  required_providers {
    # We recommend pinning to the specific version of the Docker Provider you're using
    # since new versions are released frequently
    docker = {
      source = "kreuzwerker/docker"
      #version = "2.11.0"
    }
  }
}

# Configure the docker provider
provider "docker" {
  host = "ssh://${var.docker_connect_hostname}"
}
