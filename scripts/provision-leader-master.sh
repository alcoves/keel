#!/bin/bash
set -eu

PUBLIC_IPV4=$1

hashi-up consul install \
  --server \
  --connect \
  --bootstrap-expect 1 \
  --client-addr 0.0.0.0 \
  --ssh-target-user root \
  --ssh-target-addr $PUBLIC_IPV4 \
  --ssh-target-key "~/.ssh/rusty" \
  --bind-addr "{{ GetInterfaceIP \"enp7s0\" }}"

hashi-up nomad install \
  --server \
  --address 0.0.0.0 \
  --ssh-target-user root \
  --ssh-target-addr $PUBLIC_IPV4 \
  --config-file ../scripts/nomad_server_bootstrap.hcl