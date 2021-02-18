datacenter  = "dc1"
client_addr = "0.0.0.0"
retry_join  = ["10.0.0.50"]
data_dir    = "/var/lib/consul"
bind_addr   = "{{ GetInterfaceIP \"eth0\" }}"