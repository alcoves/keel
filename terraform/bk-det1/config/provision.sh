#!/bin/bash
set -e

# This script installs dependencies required to run a server or client node
# This script does not register the node as a server or client, such a decision
# should be made by the instance during initialization.

echo "Setting some things up"
ARCH=$(arch)
NOMAD_ARCHIVE_NAME="nomad.zip"
NOMAD_VERSION="1.1.0"
CONSUL_VERSION="1.9.5"
CONSUL_ARCHIVE_NAME="consul.zip"
HASHI_RELEASE="https://releases.hashicorp.com"

if [ "$ARCH" = "aarch64" ]; then
  ARCH="arm64"
else 
  ARCH="amd64"
fi

echo "Installing dependencies"
sudo apt update

sudo apt -y install gnupg ffmpeg htop nfs-common unzip zip \
curl wget git build-essential nasm awscli jq docker.io

sudo apt upgrade -y
sudo apt autoremove -y

echo "Install snap deps"
sudo snap install cmake --classic
sudo snap install go --channel=1.16/stable --classic

echo "Install rclone"
curl https://rclone.org/install.sh | sudo bash

echo "Installing Nomad"
wget $HASHI_RELEASE/nomad/$NOMAD_VERSION/nomad_${NOMAD_VERSION}_linux_${ARCH}.zip -O $NOMAD_ARCHIVE_NAME
unzip $NOMAD_ARCHIVE_NAME && rm -f $NOMAD_ARCHIVE_NAME
sudo mv ./nomad /usr/local/bin/

echo "Installing consul"
wget $HASHI_RELEASE/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_${ARCH}.zip -O $CONSUL_ARCHIVE_NAME
unzip $CONSUL_ARCHIVE_NAME && rm -f $CONSUL_ARCHIVE_NAME
sudo mv ./consul /usr/local/bin/

echo "Cloning bken.io repos"
cd ~
git clone https://github.com/bken-io/keel/
git clone https://github.com/bken-io/tidal/
cd ~/tidal && go build main.go && cd ~

echo "Mounting NFS"
MOUNT_PATH="/mnt/tidal"
sudo mkdir $MOUNT_PATH -p
sudo chown nobody:nogroup $MOUNT_PATH
FSTAB_MOUNT="10.0.0.17:/mnt/user/tidal $MOUNT_PATH nfs rw,hard,intr,rsize=8192,wsize=8192,timeo=14 0 0"
echo $FSTAB_MOUNT | sudo tee -a /etc/fstab
sudo mount $MOUNT_PATH

echo "Setting hostname"
random-string()
{
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

HOSTNAME="tidal-$(random-string 4)"
sudo hostnamectl set-hostname $HOSTNAME