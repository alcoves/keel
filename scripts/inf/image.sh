#!/bin/bash

echo "Installing dependencies"
sudo apt update 
sudo apt -y install gnupg ffmpeg htop nfs-common unzip zip curl wget git build-essential nasm awscli jq docker.io
sudo apt upgrade -y
sudo apt autoremove -y

echo "Install snap deps"
snap install go --classic

echo "Installing bento4"
wget http://zebulon.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-637.x86_64-unknown-linux.zip
unzip Bento4-SDK-1-6-0-637.x86_64-unknown-linux.zip && rm Bento4-SDK-1-6-0-637.x86_64-unknown-linux.zip
mv Bento4-SDK-1-6-0-637.x86_64-unknown-linux bento
mv bento /usr/local/bin/bento

echo "Installing Nomad"
NOMAD_VERSION="1.0.3"
NOMAD_URL="https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip"

curl $NOMAD_URL -o "nomad.zip"
unzip nomad.zip
sudo mv nomad /usr/local/bin/
rm -rf nomad.zip

echo "Installing Consul"
CONSUL_VERSION="1.9.3"
CONSUL_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"

curl $CONSUL_URL -o "consul.zip"
unzip consul.zip
sudo mv consul /usr/local/bin/
rm -rf consul.zip

# Clone repos
cd /root
git clone https://github.com/bken-io/keel/
git clone https://github.com/bken-io/tidal/

# Install tidal deps
cd tidal && yarn && cd ..