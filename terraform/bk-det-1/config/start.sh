#!/bin/bash

echo "resyncing repos"
cd /home/ubuntu/keel && git pull -r
cd /home/ubuntu/tidal && git pull -r

echo "recompiling tidal"
go build main.go && cd /home/ubuntu

echo "creating consul/nomad dirs"
sudo mkdir -p /var/lib/consul
sudo mkdir -p /var/lib/nomad

sudo cp /home/ubuntu/keel/terraform/bk-det-1/config/consul-client.service /etc/systemd/system/consul.service
sudo systemctl enable consul.service
sudo systemctl start consul.service

sudo cp /home/ubuntu/keel/terraform/bk-det-1/config/nomad-client.service /etc/systemd/system/nomad.service
sudo systemctl enable nomad.service
sudo systemctl start nomad.service

sudo cp /home/ubuntu/keel/terraform/bk-det-1/config/consul-server.service /etc/systemd/system/consul.service
sudo systemctl enable consul.service
sudo systemctl start consul.service

sudo cp /home/ubuntu/keel/terraform/bk-det-1/config/nomad-server.service /etc/systemd/system/nomad.service
sudo systemctl enable nomad.service
sudo systemctl start nomad.service

nomad acl bootstrap
consul acl bootstrap
