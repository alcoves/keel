bootstrap_expect = 1
datacenter       = "dc1"
server           = true
ui               = true
client_addr      = "0.0.0.0"
data_dir         = "/var/lib/consul"
bind_addr        = "{{ GetInterfaceIP \"eth1\" }}"

acl {
  enabled                  = true
  enable_token_persistence = true
  default_policy           = "deny"
  down_policy              = "extend-cache"
}