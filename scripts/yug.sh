#!/bin/bash

# https://docs.yugabyte.com/latest/quick-start/install/linux/


sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget htop python-is-python3

wget https://downloads.yugabyte.com/yugabyte-2.9.1.0-linux.tar.gz
tar xvfz yugabyte-2.9.1.0-linux.tar.gz && cd yugabyte-2.9.1.0/

./bin/post_install.sh
./bin/yugabyted start
./bin/yugabyted status