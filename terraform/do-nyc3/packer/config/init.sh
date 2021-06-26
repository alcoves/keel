#!/bin/bash

NOMAD_VERSION="1.1.2"
CONSUL_VERSION="1.10.0"

source /root/.env
[[ -z "$NOMAD_TOKEN" ]] && { echo "Error: NOMAD_TOKEN must be defined"; exit 1; }
[[ -z "$CONSUL_TOKEN" ]] && { echo "Error: CONSUL_TOKEN must be defined"; exit 1; }
[[ -z "$LEADER_PRIVATE_IP" ]] && { echo "Error: LEADER_PRIVATE_IP must be defined"; exit 1; }

echo "Installing dependencies"
sleep 30 # Wait for full system boot
sudo apt update && sudo apt upgrade -y -o Dpkg::Options::='--force-confold'
sudo apt install -y -o Dpkg::Options::='--force-confold' gnupg ffmpeg htop \
nfs-common unzip zip curl wget git build-essential nasm awscli jq
sudo apt autoremove -y

echo "Install snap deps"
sudo snap install go --classic

echo "Installing node"
curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh

echo "Installing Nomad"
NOMAD_URL="https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip"
curl $NOMAD_URL -o "nomad.zip"
unzip nomad.zip
sudo mv nomad /usr/local/bin/
rm -rf nomad.zip

echo "Installing Consul"
CONSUL_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"
curl $CONSUL_URL -o "consul.zip"
unzip consul.zip
sudo mv consul /usr/local/bin/
rm -rf consul.zip

echo "Creating systemd entries"
SERVICES="consul-leader consul-worker nomad-leader nomad-worker"
for SERVICE in $SERVICES; do
EXEC_START=""
BINARY=$(echo $SERVICE | cut -d "-" -f1)

if [ "$BINARY" = "consul" ]; then
  EXEC_START="/usr/local/bin/consul agent -config-file /root/${SERVICE}.hcl"
else
  EXEC_START="/usr/local/bin/nomad agent -config /root/${SERVICE}.hcl"
fi

cat <<EOF > /etc/systemd/system/${SERVICE}.service
[Unit]
Description=${SERVICE}
Wants=network-online.target
After=network-online.target
[Service]
ExecStart= /bin/sh -c "${EXEC_START}"
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
EOF
done

echo "Writing Consul Leader config"
cat <<EOF > /root/consul-leader.hcl
bootstrap_expect = 2
datacenter       = "dc1"
server           = true
client_addr      = "0.0.0.0"
data_dir         = "/var/lib/consul"
retry_join       = ["${LEADER_PRIVATE_IP}"]
bind_addr        = "{{ GetInterfaceIP \"eth1\" }}"

ui_config {
  enabled = true
}

acl {
  enabled                  = true
  enable_token_persistence = true
  default_policy           = "deny"
  down_policy              = "extend-cache"
}
EOF

echo "Writing Consul Worker config"
cat <<EOF > /root/consul-worker.hcl
datacenter  = "dc1"
client_addr = "0.0.0.0"
data_dir    = "/var/lib/consul"
retry_join  = ["${LEADER_PRIVATE_IP}"]
bind_addr   = "{{ GetInterfaceIP \"eth1\" }}"

acl {
  tokens {
    default = "${CONSUL_TOKEN}"
  }
}
EOF

echo "Writing Nomad Leader config"
cat <<EOF > /root/nomad-leader.hcl
datacenter = "dc1"
region     = "do-nyc3"
data_dir   = "/var/lib/nomad"
bind_addr  = "{{ GetInterfaceIP \"eth1\" }}"

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
  bootstrap_expect = 2
  enabled          = true
}

acl {
  enabled = true
}

consul {
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auth                = "admin:password"
  address             = "127.0.0.1:8500"
  token               = "${CONSUL_TOKEN}"
}

client { enabled = false }

plugin "raw_exec" {
  config {
    enabled = true
  }
}
EOF

echo "Writing Nomad Worker config"
cat <<EOF > /root/nomad-worker.hcl
datacenter = "dc1"
region     = "do-nyc3"
data_dir   = "/var/lib/nomad"
bind_addr  = "{{ GetInterfaceIP \"eth1\" }}"

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

consul {
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auth                = "admin:password"
  address             = "127.0.0.1:8500"
  token               = "${CONSUL_TOKEN}"
}

client {
  enabled           = true
  network_interface = "eth1"
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
EOF
