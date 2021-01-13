resource "docker_network" "private_network" {
  name            = "private_network"
  check_duplicate = true
  driver          = "bridge"
  options = {
    "com.docker.network.bridge.name"                 = "docker1",
    "com.docker.network.bridge.enable_ip_masquerade" = "true",
    "com.docker.network.bridge.enable_icc"           = "true",
    "com.docker.network.bridge.host_binding_ipv4"    = "0.0.0.0"
    "com.docker.network.driver.mtu"                  = "1500"
  }
}

resource "docker_network" "public_network" {
  name            = "public_network"
  check_duplicate = true
  driver          = "bridge"
  options = {
    "com.docker.network.bridge.name"                 = "docker2",
    "com.docker.network.bridge.enable_ip_masquerade" = "true",
    "com.docker.network.bridge.enable_icc"           = "true",
    "com.docker.network.bridge.host_binding_ipv4"    = "0.0.0.0"
    "com.docker.network.driver.mtu"                  = "1500"
  }
}

