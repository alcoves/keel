#!/bin/bash

NUMBER_OF_INSTANCES=${1:-1}
INSTANCE_SIZE=${2:-s-2vcpu-4gb}

random-string()
{
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

for (( i=0; i<$NUMBER_OF_INSTANCES; ++i)); do
  DROPLET_NAME="tidal-$(random-string 4)"
  echo "creating $DROPLET_NAME"

  doctl compute droplet create \
  $DROPLET_NAME \
  --region nyc3 \
  --image 73220041 \
  --enable-monitoring \
  --size $INSTANCE_SIZE \
  --enable-private-networking \
  --user-data-file ./start.sh \
  --tag-names "ssh,vpc,fabio" \
  --vpc-uuid 88047a46-8be0-4d10-8d25-d5a683505fd6 \
  --ssh-keys 26:e4:37:18:61:e9:29:76:20:68:e1:7f:eb:49:07:2e \
  --ssh-keys a9:da:f0:ba:e6:95:4a:4a:2a:ae:dd:e6:60:5b:bb:10
done