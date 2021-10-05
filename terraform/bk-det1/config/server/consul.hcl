bootstrap_expect = 4
datacenter       = "dc1"
server           = true
ui               = true
client_addr      = "0.0.0.0"
bind_addr        = "$PRIVATE_IP"
data_dir         = "/var/lib/consul"

acl {
  enabled                  = true
  enable_token_persistence = true
  default_policy           = "allow"
}