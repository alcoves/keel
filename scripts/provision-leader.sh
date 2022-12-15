#!/bin/bash
set -eu

MASTER_LEADER=$1
PUBLIC_IPV4=$2

hashi-up consul install \
  --server \
  --connect \
  --bootstrap-expect 2 \
  --client-addr 0.0.0.0 \
  --ssh-target-user root \
  --retry-join $MASTER_LEADER \
  --ssh-target-addr $PUBLIC_IPV4 \
  --ssh-target-key "~/.ssh/rusty" \
  --bind-addr "{{ GetInterfaceIP \"enp7s0\" }}"

hashi-up nomad install \
  --server \
  --address 0.0.0.0 \
  --bootstrap-expect 2 \
  --ssh-target-user root \
  --retry-join $MASTER_LEADER \
  --ssh-target-addr $PUBLIC_IPV4 \
  --ssh-target-key "~/.ssh/rusty" \
  --advertise "{{ GetInterfaceIP \"enp7s0\" }}"