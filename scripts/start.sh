#!/bin/bash

echo "resyncing repos"
cd /root/tidal && git pull
cd /root/keel && git pull

echo "creating consul/nomad dirs"
mkdir -p /var/lib/consul
mkdir -p /var/lib/nomad

echo "configuring consul client"
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

echo "cofiguring nomad client"
sudo cp /root/keel/nomad/client.service /etc/systemd/system/nomad-client.service
sudo systemctl enable nomad-client.service
sudo systemctl start nomad-client.service

# Configure Consul Server
# sudo cp /root/keel/consul/server.service /etc/systemd/system/consul-server.service
# sudo systemctl enable consul-server.service
# sudo systemctl start consul-server.service

# Configure Nomad Server
# sudo cp /root/keel/nomad/server.service /etc/systemd/system/nomad-server.service
# sudo systemctl enable nomad-server.service
# sudo systemctl start nomad-server.service
