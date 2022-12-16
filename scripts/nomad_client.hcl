datacenter = "dc1"
data_dir   = "/opt/nomad"
bind_addr  = "0.0.0.0"

advertise {
  http = "{{ GetInterfaceIP \"enp7s0\" }}"
  rpc  = "{{ GetInterfaceIP \"enp7s0\" }}"
  serf = "{{ GetInterfaceIP \"enp7s0\" }}"
}

client {
  enabled           = true
  network_interface = "enp7s0"
}

plugin "docker" {
  config {
    volumes {
      enabled = true
    }
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
