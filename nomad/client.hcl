region     = "us"
datacenter = "dc1"
bind_addr  = "0.0.0.0"
data_dir   = "/var/lib/nomad"

addresses {
  http = "127.0.0.1"
}

advertise {
  http = "{{ GetInterfaceIP \"eth1\" }}"
  rpc  = "{{ GetInterfaceIP \"eth1\" }}"
  serf = "{{ GetInterfaceIP \"eth1\" }}"
}

telemetry {
  disable_hostname = true
  prometheus_metrics = true
  collection_interval = "1s"
  publish_node_metrics = true
  publish_allocation_metrics = true
}

consul {
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  address             = "127.0.0.1:8500"
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