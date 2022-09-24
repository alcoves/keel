#!/bin/bash
set -eu

RETRY_JOIN=""

MODE=$1
PUBLIC_LEADER_IPV4s=$2
PRIVATE_LEADER_IPV4s=$3

if [ "$MODE" != "leaders" ] && [ "$MODE" != "workers" ]; then
  echo "the first argument must be either \"leaders\" or \"workers\", it is $MODE"
  exit 1
fi

IFS="," read -ra LEADER_PUBLIC_IPV4_ARRAY <<< $PUBLIC_LEADER_IPV4s
IFS="," read -ra LEADER_PRIVATE_IPV4_ARRAY <<< $PRIVATE_LEADER_IPV4s
ARRAY_LENGTH="${#LEADER_PUBLIC_IPV4_ARRAY[@]}"

for IP in "${LEADER_PRIVATE_IPV4_ARRAY[@]}"; do
  RETRY_JOIN+="--retry-join $IP "
done

if [ "$MODE" == "leaders" ]; then
  INDEX=0
  for PRIVATE_IPV4 in "${LEADER_PRIVATE_IPV4_ARRAY[@]}"; do
    PUBLIC_IPV4=${LEADER_PUBLIC_IPV4_ARRAY[$INDEX]}

    hashi-up consul install \
      --server \
      --connect \
      --client-addr 0.0.0.0 \
      --ssh-target-user root \
      --bind-addr $PRIVATE_IPV4 \
      --ssh-target-addr $PUBLIC_IPV4 \
      --ssh-target-key "~/.ssh/rusty" \
      --bootstrap-expect $ARRAY_LENGTH \
      $RETRY_JOIN

    hashi-up nomad install \
      --server \
      --address 0.0.0.0 \
      --ssh-target-user root \
      --advertise $PRIVATE_IPV4 \
      --ssh-target-addr $PUBLIC_IPV4 \
      --ssh-target-key "~/.ssh/rusty" \
      --bootstrap-expect $ARRAY_LENGTH

    let INDEX=${INDEX}+1
  done
fi

if [ "$MODE" == "workers" ]; then
  INDEX=0
  for PUBLIC_IPV4 in "${LEADER_PUBLIC_IPV4_ARRAY[@]}"; do

    hashi-up consul install \
      --connect \
      --client-addr 0.0.0.0 \
      --ssh-target-user root \
      --ssh-target-addr $PUBLIC_IPV4 \
      --ssh-target-key "~/.ssh/rusty" \
      --bind-addr "{{ GetInterfaceIP \"enp7s0\" }}" \
      $RETRY_JOIN

    hashi-up nomad install \
      --ssh-target-user root \
      --ssh-target-addr $PUBLIC_IPV4 \
      --ssh-target-key "~/.ssh/rusty" \
      --config-file ../config/nomad_client.hcl

    let INDEX=${INDEX}+1
  done
fi