#!/bin/bash

cd /root/tidal
git reset --hard origin/master
git pull

cd /root/keel
git reset --hard origin/master
git pull

cd ~

sudo apt update ||
sudo apt upgrade -y ||

exit 0