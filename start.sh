#!/bin/bash

cd /root/tidal && git pull
cd /root/keel && git pull

# Configure Consul Client
sudo cp /root/keel/consul/client.service /etc/systemd/system/consul-client.service
sudo systemctl enable consul-client.service
sudo systemctl start consul-client.service

echo "waiting for consul to start and join"
sleep 20;

echo "cofiguring nomad client"
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
