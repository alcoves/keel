# Node basics

sudo apt install -y awscli zip unzip jq build-essential git wget curl nfs-common htop ca-certificates gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/root/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/root \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# On Local

curl -sLS https://get.hashi-up.dev | sh
sudo install hashi-up /usr/local/bin/

hashi-up version

export SERVER_1_PRIVATE_IP=10.132.0.4
export SERVER_1_PUBLIC_IP=159.203.97.247

export SERVER_2_PRIVATE_IP=10.132.0.6
export SERVER_2_PUBLIC_IP=165.227.127.61

export WORKER_1_PRIVATE_IP=10.132.0.9
export WORKER_1_PUBLIC_IP=159.65.44.243

# Servers

hashi-up consul install \
  --connect \
  --ssh-target-addr $SERVER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" \
  --server \
  --client-addr 0.0.0.0 \
  --bind-addr $SERVER_1_PRIVATE_IP \
  --advertise-addr $SERVER_1_PRIVATE_IP \
  --bootstrap-expect 2 \
  --retry-join $SERVER_1_PRIVATE_IP --retry-join $SERVER_2_PRIVATE_IP
  
hashi-up consul install \
  --connect \
  --ssh-target-addr $SERVER_2_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" \
  --server \
  --client-addr 0.0.0.0 \
  --bind-addr $SERVER_2_PRIVATE_IP \
  --advertise-addr $SERVER_2_PRIVATE_IP \
  --bootstrap-expect 2 \
  --retry-join $SERVER_1_PRIVATE_IP --retry-join $SERVER_2_PRIVATE_IP

hashi-up nomad install \
  --ssh-target-addr $SERVER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" \
  --server \
  --address 0.0.0.0 \
  --advertise "{{ GetInterfaceIP \"eth1\" }}" \
  --bootstrap-expect 2
   
hashi-up nomad install \
  --ssh-target-addr $SERVER_2_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" \
  --server \
  --address 0.0.0.0 \
  --advertise "{{ GetInterfaceIP \"eth1\" }}" \
  --bootstrap-expect 2

hashi-up vault install \
  --ssh-target-addr $SERVER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" \
  --storage consul \
  --api-addr http://$SERVER_1_PRIVATE_IP:8200

hashi-up vault install \
  --ssh-target-addr $SERVER_2_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" \
  --storage consul \
  --api-addr http://$SERVER_2_PRIVATE_IP:8200

# Workers

hashi-up consul install \
  --connect \
  --ssh-target-addr $WORKER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" \
  --client-addr 0.0.0.0 \
  --bind-addr $WORKER_1_PRIVATE_IP \
  --advertise-addr $WORKER_1_PRIVATE_IP \
  --retry-join $SERVER_1_PRIVATE_IP --retry-join $SERVER_2_PRIVATE_IP

hashi-up nomad install \
  --ssh-target-addr $WORKER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" \
  --config-file ./nomad_client.hcl

# REMOVE

hashi-up nomad uninstall \
  --ssh-target-addr $SERVER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &

hashi-up nomad uninstall \
  --ssh-target-addr $SERVER_2_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &

hashi-up nomad uninstall \
  --ssh-target-addr $WORKER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &

hashi-up consul uninstall \
  --ssh-target-addr $SERVER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &

hashi-up consul uninstall \
  --ssh-target-addr $SERVER_2_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &

hashi-up consul uninstall \
  --ssh-target-addr $WORKER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &

hashi-up vault uninstall \
  --ssh-target-addr $SERVER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &

hashi-up vault uninstall \
  --ssh-target-addr $SERVER_2_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &

hashi-up vault uninstall \
  --ssh-target-addr $WORKER_1_PUBLIC_IP \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty" &
