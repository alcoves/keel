#!/bin/bash

cd /root/tidal
git reset --hard origin/master
git pull

cd /root/keel
git reset --hard origin/master
git pull

cd ~

sudo apt update || true
sudo apt upgrade -y || true

exit 0