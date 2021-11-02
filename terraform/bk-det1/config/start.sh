#!/bin/bash
set -eux

# Example: worker 10.0.0.30 1234

export TYPE=$1
export PRIVATE_IP=$2
export CONSUL_MASTER_TOKEN=$3

if [ -z "$TYPE" ]; then
  echo "first argument must be either worker or server"
  exit 1
fi

if [ -z "$PRIVATE_IP" ]; then
  echo "second argument must be a private ip"
  exit 1
fi

echo "resyncing repos"
[ -d "/home/ubuntu/keel" ] && cd /home/ubuntu/keel && echo git reset --hard && git pull -r && cd ~

echo "recompiling tidal"
[ -d "/home/ubuntu/tidal" ] && cd /home/ubuntu/tidal && echo git reset --hard && git pull -r && cd ~

echo "creating consul/nomad dirs"
sudo mkdir -p /var/lib/consul
sudo rm -rf /etc/consul.d
sudo mkdir -p /etc/consul.d

sudo mkdir -p /var/lib/nomad
sudo rm -rf /etc/nomad.d
sudo mkdir -p /etc/nomad.d

SUB_VARS='$PRIVATE_IP:$CONSUL_MASTER_TOKEN'

sudo cp /home/ubuntu/keel/terraform/bk-det1/config/consul.service /etc/systemd/system/consul.service
envsubst "$SUB_VARS" < /home/ubuntu/keel/terraform/bk-det1/config/${TYPE}/consul.hcl > /etc/consul.d/consul.hcl
sudo systemctl enable consul.service
sudo systemctl stop consul.service
sudo systemctl start consul.service

sudo cp /home/ubuntu/keel/terraform/bk-det1/config/nomad.service /etc/systemd/system/nomad.service
envsubst "$SUB_VARS" < /home/ubuntu/keel/terraform/bk-det1/config/${TYPE}/nomad.hcl > /etc/nomad.d/nomad.hcl
sudo systemctl enable nomad.service
sudo systemctl stop nomad.service
sudo systemctl start nomad.service