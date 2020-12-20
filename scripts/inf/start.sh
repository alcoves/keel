#!/bin/bash

# TODO :: remove when next tidal image is created
echo "installing go"
snap install go --classic

echo "resyncing repos"
cd /root/tidal && git pull

echo "recompiling tidal"
export HOME="/root" # Needed for golang to not crash
go build main.go

cd /root/keel && git pull

echo "creating consul/nomad dirs"
mkdir -p /var/lib/consul
mkdir -p /var/lib/nomad

echo "configuring consul client"
sudo cp /root/keel/consul/client.service /etc/systemd/system/consul.service
sudo systemctl enable consul.service
sudo systemctl start consul.service

echo "waiting for consul to start and join"
sleep 20;

echo "setting up digitalocean profile"
aws configure set aws_access_key_id "$(consul kv get secrets/DO_ACCESS_KEY_ID)" --profile digitalocean
aws configure set aws_secret_access_key "$(consul kv get secrets/DO_SECRET_ACCESS_KEY)" --profile digitalocean

echo "setting up wasabi profile"
aws configure set aws_access_key_id "$(consul kv get secrets/WASABI_ACCESS_KEY_ID)" --profile wasabi
aws configure set aws_secret_access_key "$(consul kv get secrets/WASABI_SECRET_ACCESS_KEY)" --profile wasabi

echo "cofiguring nomad client"
sudo cp /root/keel/nomad/client.service /etc/systemd/system/nomad.service
sudo systemctl enable nomad.service
sudo systemctl start nomad.service

# Configure Consul Server
# sudo cp /root/keel/consul/server.service /etc/systemd/system/consul.service
# sudo systemctl enable consul.service
# sudo systemctl start consul.service

# Configure Nomad Server
# sudo cp /root/keel/nomad/server.service /etc/systemd/system/nomad.service
# sudo systemctl enable nomad.service
# sudo systemctl start nomad.service
