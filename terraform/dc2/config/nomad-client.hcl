region     = "us"
datacenter = "dc2"
bind_addr  = "{{ GetInterfaceIP \"eth0\" }}"
data_dir   = "/var/lib/nomad"

addresses {
  http = "0.0.0.0"
}

advertise {
  http = "{{ GetInterfaceIP \"eth0\" }}"
  rpc  = "{{ GetInterfaceIP \"eth0\" }}"
  serf = "{{ GetInterfaceIP \"eth0\" }}"
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
  network_interface = "eth0"
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}