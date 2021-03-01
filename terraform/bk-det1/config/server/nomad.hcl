datacenter = "dc1"
region     = "bk-det-1"
data_dir   = "/var/lib/nomad"
bind_addr  = "{{ GetInterfaceIP \"eth0\" }}"

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

server {
  bootstrap_expect = 1
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