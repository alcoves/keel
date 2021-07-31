datacenter = "dc1"
region     = "bk-det-1"
bind_addr  = "{PRIVATE_IP}"
data_dir   = "/var/lib/nomad"

addresses {
  http = "0.0.0.0"
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
  token               = "{CONSUL_MASTER_TOKEN}"
}

client {
  enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}