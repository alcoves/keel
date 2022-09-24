#!/bin/bash
set -eu

PUBLIC_IPV4=$1

hashi-up nomad uninstall \
  --ssh-target-addr $PUBLIC_IPV4 \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty"

hashi-up consul uninstall \
  --ssh-target-addr $PUBLIC_IPV4 \
  --ssh-target-user root \
  --ssh-target-key "~/.ssh/rusty"