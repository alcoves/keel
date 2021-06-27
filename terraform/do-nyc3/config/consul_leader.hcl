bootstrap_expect = 2
datacenter       = "nyc3"
server           = true
client_addr      = "0.0.0.0"
data_dir         = "/var/lib/consul"
bind_addr        = "{{ GetInterfaceIP \"eth1\" }}"
retry_join       = ["${LEADER_IP}"]

ui_config {
  enabled = true
}

telemetry {
  disable_hostname          = true
  prometheus_retention_time = "15m"
}

acl {
  enabled                  = true
  enable_token_persistence = true
  default_policy           = "allow"
}