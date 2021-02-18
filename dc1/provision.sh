#!/bin/bash
set -e

# This script installs dependencies required to run a server or client node
# This script does not register the node as a server or client, such a decision
# should be made by the instance during initialization.

echo "Setting some things up"
ARCH=$(arch)
NOMAD_ARCHIVE_NAME="nomad.zip"
NOMAD_VERSION="1.0.3"
CONSUL_VERSION="1.9.3"
CONSUL_ARCHIVE_NAME="consul.zip"
HASHI_RELEASE="https://releases.hashicorp.com"

echo "Installing dependencies"
sudo apt update

sudo apt -y install gnupg ffmpeg htop nfs-common unzip zip \
curl wget git build-essential nasm awscli jq docker.io

sudo apt upgrade -y
sudo apt autoremove -y

echo "Install snap deps"
sudo snap install go --classic
sudo snap install cmake --classic

echo "Installing Nomad"
wget $HASHI_RELEASE/nomad/$NOMAD_VERSION/nomad_${NOMAD_VERSION}_linux_arm64.zip -O $NOMAD_ARCHIVE_NAME
unzip $NOMAD_ARCHIVE_NAME && rm -f $NOMAD_ARCHIVE_NAME
sudo mv ./nomad /usr/local/bin/

echo "Installing consul"
wget $HASHI_RELEASE/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_arm64.zip -O $CONSUL_ARCHIVE_NAME
unzip $CONSUL_ARCHIVE_NAME && rm -f $CONSUL_ARCHIVE_NAME
sudo mv ./consul /usr/local/bin/

echo "Compiling bento4"
git clone https://github.com/axiomatic-systems/Bento4.git
mkdir -p Bento4/bin && cd Bento4/bin
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo cp ~/Bento4/bin/* /usr/local/bin/ || true

echo "Cloning bken.io repos"
cd ~
git clone https://github.com/bken-io/keel/
git clone https://github.com/bken-io/tidal/

echo "Setting hostname"
random-string()
{
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

HOSTNAME="bken-$(random-string 4)"
hostnamectl set-hostname $HOSTNAME