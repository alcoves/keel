#!/bin/bash
set -e

# server or client
MODE=$1

# Switch to dev branch
cd keel && git checkout dev && cd ~

# Create service definitions
sudo cp ~/keel/${MODE}/nomad/${MODE}.service /etc/systemd/system/nomad-${MODE}.service
sudo cp ~/keel/${MODE}/consul/${MODE}.service /etc/systemd/system/consul-${MODE}.service

# Start nomad
sudo systemctl enable nomad-${MODE}.service
sudo systemctl start nomad-${MODE}.service

# Start consul
sudo systemctl enable consul-${MODE}.service
sudo systemctl start consul-${MODE}.service
