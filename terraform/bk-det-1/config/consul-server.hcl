bootstrap_expect = 1
datacenter       = "dc1"
server           = true
ui               = true
client_addr      = "0.0.0.0"
data_dir         = "/var/lib/consul"
bind_addr        = "{{ GetInterfaceIP \"eth0\" }}"

acl {
  enabled = true
  default_policy = "allow"
  enable_token_persistence = true
}