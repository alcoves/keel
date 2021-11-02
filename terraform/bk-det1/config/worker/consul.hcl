datacenter  = "dc1"
client_addr = "0.0.0.0"
retry_join  = ["10.0.0.50"]
bind_addr   = "$PRIVATE_IP"
data_dir    = "/var/lib/consul"

acl {
  enabled        = true
  default_policy = "allow"
  down_policy    = "extend-cache"
  tokens {
    agent = "$CONSUL_MASTER_TOKEN"
  }
}