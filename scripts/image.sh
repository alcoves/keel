#!/bin/bash

echo "Installing dependencies"
sudo apt update && sudo apt -y install gnupg ffmpeg htop nfs-common unzip zip curl wget git build-essential nasm awscli jq docker.io
sudo apt upgrade -y
sudo apt autoremove -y

echo "Installing Nomad"
NOMAD_VERSION="1.0.0-beta2"
NOMAD_URL="https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip"

curl $NOMAD_URL -o "nomad.zip"
unzip nomad.zip
sudo mv nomad /usr/local/bin/
rm -rf nomad.zip

echo "Installing Consul"
CONSUL_VERSION="1.8.5"
CONSUL_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"

curl $CONSUL_URL -o "consul.zip"
unzip consul.zip
sudo mv consul /usr/local/bin/
rm -rf consul.zip

echo "Installing Rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y

echo "Installing node"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install npm -y 
sudo npm i -g yarn

# Clone repos
cd /root
git clone https://github.com/bken-io/keel/
git clone https://github.com/bken-io/tidal/

# Install tidal deps
cd tidal && yarn && cd ..