datacenter  = "dc1"
client_addr = "0.0.0.0"
data_dir    = "/var/lib/consul"
retry_join  = ["${leader_node_private_ip}"]
bind_addr   = "{{ GetInterfaceIP \"eth1\" }}"