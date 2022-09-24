#!/bin/bash
set -eu

MASTER_LEADER=$1
PUBLIC_IPV4=$2

hashi-up consul install \
  --connect \
  --client-addr 0.0.0.0 \
  --ssh-target-user root \
  --retry-join $MASTER_LEADER \
  --ssh-target-addr $PUBLIC_IPV4 \
  --ssh-target-key "~/.ssh/rusty" \
  --bind-addr "{{ GetInterfaceIP \"enp7s0\" }}" \

hashi-up nomad install \
  --ssh-target-user root \
  --ssh-target-addr $PUBLIC_IPV4 \
  --ssh-target-key "~/.ssh/rusty" \
  --config-file ../config/nomad_client.hcl