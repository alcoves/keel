#!/bin/bash

doctl compute droplet create \
tidal \
--region nyc3 \
--size s-1vcpu-1gb \
--tag-names "ssh,vpc" \
--image ubuntu-20-04-x64 \
--enable-private-networking \
--user-data-file ./image.sh \
--vpc-uuid 88047a46-8be0-4d10-8d25-d5a683505fd6 \
--ssh-keys 26:e4:37:18:61:e9:29:76:20:68:e1:7f:eb:49:07:2e \
--ssh-keys a9:da:f0:ba:e6:95:4a:4a:2a:ae:dd:e6:60:5b:bb:10