data_dir  = "/var/lib/nomad"
bind_addr = "127.0.0.1"

advertise {
  http = "{{ GetInterfaceIP \"eth1\" }}"
  rpc  = "{{ GetInterfaceIP \"eth1\" }}"
  surf = "{{ GetInterfaceIP \"eth1\" }}"
}

client {
  enabled           = true
  network_interface = "eth1"
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}