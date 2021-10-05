datacenter = "dc1"
region     = "bk-det-1"
bind_addr  = "$PRIVATE_IP"
data_dir   = "/var/lib/nomad"

addresses {
  http = "0.0.0.0"
}

telemetry {
  disable_hostname = true
  prometheus_metrics = true
  collection_interval = "15s"
  publish_node_metrics = true
  publish_allocation_metrics = true
}

server {
  bootstrap_expect = 4
  enabled          = true
}

acl {
  enabled = true
}

client { enabled = false }

plugin "raw_exec" {
  config {
    enabled = true
  }
}