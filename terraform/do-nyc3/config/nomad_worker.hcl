datacenter = "nyc3"
region     = "do-nyc3"
data_dir   = "/var/lib/nomad"
bind_addr  = "{{ GetInterfaceIP \"eth1\" }}"

addresses {
  http = "0.0.0.0"
}

telemetry {
  disable_hostname = true
  prometheus_metrics = true
  collection_interval = "5s"
  publish_node_metrics = true
  publish_allocation_metrics = false
}

consul {
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auth                = "admin:password"
  address             = "127.0.0.1:8500"
  token               = "${CONSUL_TOKEN}"
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