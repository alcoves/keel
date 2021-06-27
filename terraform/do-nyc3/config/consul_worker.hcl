datacenter  = "nyc3"
client_addr = "0.0.0.0"
data_dir    = "/var/lib/consul"
bind_addr   = "{{ GetInterfaceIP \"eth1\" }}"
retry_join  = ["${LEADER_IP}"]

acl {
  tokens {
    default = "${CONSUL_TOKEN}"
  }
}