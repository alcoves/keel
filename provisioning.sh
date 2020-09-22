#!/bin/bash

echo "Setting environment variables"
NOMAD_VERSION="0.12.4"
CONSUL_VERSION="1.8.3"

echo "Installing dependencies"
sudo apt update && sudo apt -y install gnupg ffmpeg htop nfs-common unzip zip curl wget git build-essential nasm awscli jq docker.io

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

echo "Installing Rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y

echo "Installing node"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs && npm i -g yarn

# Clone repos
cd /root
git clone https://github.com/bken-io/keel/
git clone https://github.com/bken-io/tidal/

# Install tidal deps
cd tidal && yarn && cd ..

# Setup dirs
mkdir -p /var/lib/consul
mkdir -p /var/lib/nomad

# Configure Consul Client
sudo cp /root/keel/consul/client.service /etc/systemd/system/consul-client.service
sudo systemctl enable consul-client.service
sudo systemctl start consul-client.service

echo "waiting for consul to start and join"
sleep 20;

echo "setting up digitalocean profile"
aws configure set aws_access_key_id "$(consul kv get secrets/DO_ACCESS_KEY_ID)" --profile digitalocean
aws configure set aws_secret_access_key "$(consul kv get secrets/DO_SECRET_ACCESS_KEY)" --profile digitalocean

echo "setting up wasabi profile"
aws configure set aws_access_key_id "$(consul kv get secrets/WASABI_ACCESS_KEY_ID)" --profile wasabi
aws configure set aws_secret_access_key "$(consul kv get secrets/WASABI_SECRET_ACCESS_KEY)" --profile wasabi

# Configure Nomad Client
sudo cp /root/keel/nomad/client.service /etc/systemd/system/nomad-client.service
sudo systemctl enable nomad-client.service
sudo systemctl start nomad-client.service

# Server configuration

# Configure Consul Server
# sudo cp /root/keel/consul/server.service /etc/systemd/system/consul-server.service
# sudo systemctl enable consul-server.service
# sudo systemctl start consul-server.service

# Configure Nomad Server
# sudo cp /root/keel/nomad/server.service /etc/systemd/system/nomad-server.service
# sudo systemctl enable nomad-server.service
# sudo systemctl start nomad-server.service
