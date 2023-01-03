#!/bin/bash
set -eux

apt update

apt install -y \
  awscli htop apt-transport-https \
  wget curl zip gnupg unzip lsb-release \
  ca-certificates software-properties-common

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

service docker start

FFMPEG_VERSION="ffmpeg-n5.1-latest-linux64-gpl-5.1"
wget -q https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/${FFMPEG_VERSION}.tar.xz
tar -xvf ${FFMPEG_VERSION}.tar.xz
mv ${FFMPEG_VERSION}/bin/* /usr/bin/
rm -rf ${FFMPEG_VERSION}*