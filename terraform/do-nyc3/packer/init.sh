#!/bin/bash

NOMAD_VERSION="1.1.2"
CONSUL_VERSION="1.10.0"

echo "Installing dependencies"
sleep 30 # Wait for full system boot
sudo apt update && sudo apt upgrade -y -o Dpkg::Options::='--force-confold'
sudo apt install -y -o Dpkg::Options::='--force-confold' gnupg ffmpeg htop \
nfs-common unzip zip curl wget git build-essential nasm awscli jq docker.io
sudo apt autoremove -y

echo "Install snap deps"
sudo snap install go --classic

echo "Installing node"
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -

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