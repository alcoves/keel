#!/bin/bash
set -e

# Install deps
sudo apt update
sudo apt install -y unzip docker.io ffmpeg jq awscli

# Install nodejs
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm i -g yarn aws-sdk
npm link aws-sdk

# Install nomad
wget https://releases.hashicorp.com/nomad/0.10.4/nomad_0.10.4_linux_amd64.zip
unzip nomad_0.10.4_linux_amd64.zip
rm nomad_0.10.4_linux_amd64.zip
sudo mv nomad /usr/local/bin

# Install consul
wget https://releases.hashicorp.com/consul/1.7.2/consul_1.7.2_linux_amd64.zip
unzip consul_1.7.2_linux_amd64.zip
rm consul_1.7.2_linux_amd64.zip
sudo mv consul /usr/local/bin

# Clone keel
git clone https://github.com/bken-io/keel.git
