#!/bin/bash

sleep 30

echo "Installing dependencies"
sudo apt update && sudo apt upgrade -y -o Dpkg::Options::='--force-confold'
sudo apt install -y -o Dpkg::Options::='--force-confold' jq unzip wget curl nfs-common
sudo apt autoremove -y

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

echo "Configure Consul Server"
sudo systemctl enable consul.service
sudo systemctl start consul.service

echo "Waiting for consul to start"
sleep 10

echo "Configure Nomad Server"
sudo systemctl enable nomad.service
sudo systemctl start nomad.service