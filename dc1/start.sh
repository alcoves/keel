#!/bin/bash

echo "setting up"
export HOME="/home/ubuntu"

echo "resyncing repos"
cd /home/ubuntu/keel && git pull -r
cd /home/ubuntu/tidal && git pull -r

echo "recompiling tidal"
go build main.go && cd $HOME

echo "creating consul/nomad dirs"
sudo mkdir -p /var/lib/consul
sudo mkdir -p /var/lib/nomad

echo "configuring consul client"
sudo cp $HOME/keel/dc1/config/consul-client.service /etc/systemd/system/consul-client.service
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
sudo cp $HOME/keel/dc1/config/nomad-client.service /etc/systemd/system/nomad.service
sudo systemctl enable nomad.service
sudo systemctl start nomad.service

# Configure Consul Server
# sudo cp $HOME/keel/dc1/config/consul-server.service /etc/systemd/system/consul.service
# sudo systemctl enable consul.service
# sudo systemctl start consul.service

# Configure Nomad Server
# sudo cp $HOME/keel/dc1/config/nomad-server.service /etc/systemd/system/nomad.service
# sudo systemctl enable nomad.service
# sudo systemctl start nomad.service

# nomad acl bootstrap
# consul acl bootstrap
