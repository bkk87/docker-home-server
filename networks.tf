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
  # Manually run: iptables -I DOCKER-USER -m conntrack --ctstate NEW -s 172.19.0.0/16 -m addrtype --dst-type LOCAL -j DROP
  # Blocks
  #     Access to host running docker daemon
  # Does not block
  #     Container to container traffic
  #     Local LAN
  #     Internet
  #     Access originating from other docker networks
  ipam_config {
    subnet   = "172.19.0.0/16"
    ip_range = "172.19.0.0/24"
    gateway  = "172.19.0.1"
  }
  options = {
    "com.docker.network.bridge.name"                 = "docker2",
    "com.docker.network.bridge.enable_ip_masquerade" = "true",
    "com.docker.network.bridge.enable_icc"           = "true",
    "com.docker.network.bridge.host_binding_ipv4"    = "0.0.0.0"
    "com.docker.network.driver.mtu"                  = "1500"
  }
}

