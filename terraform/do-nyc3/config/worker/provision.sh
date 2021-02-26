#!/bin/bash

sleep 30

echo "Installing dependencies"
sudo apt update && sudo apt upgrade -y -o Dpkg::Options::='--force-confold'
sudo apt install -y -o Dpkg::Options::='--force-confold' gnupg ffmpeg htop \
nfs-common unzip zip curl wget git build-essential nasm awscli jq docker.io
sudo apt autoremove -y

echo "Install snap deps"
sudo snap install go --classic

echo "Installing bento4"
# TODO :: manually build instead of depending on these binaries
wget http://zebulon.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-637.x86_64-unknown-linux.zip
unzip Bento4-SDK-1-6-0-637.x86_64-unknown-linux.zip && rm Bento4-SDK-1-6-0-637.x86_64-unknown-linux.zip
mv Bento4-SDK-1-6-0-637.x86_64-unknown-linux bento
sudo mv bento /usr/local/bin/bento

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

cd ~
git clone https://github.com/bken-io/keel/
git clone https://github.com/bken-io/tidal/

cd tidal && go build main.go && cd ..

echo "Configure Consul Client"
sudo systemctl enable consul.service
sudo systemctl start consul.service

echo "Waiting for consul to start"
sleep 10

echo "Configure Nomad Cleint"
sudo systemctl enable nomad.service
sudo systemctl start nomad.service