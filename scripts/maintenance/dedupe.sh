#!/bin/bash

set -e

### WARNING ###
# This script CANNOT run while tidal is processing videos
# You MUST stop all tidal jobs before this script runs

# This script will delete tidal videos that are not referenced in wasabi
# It will also delete all resource for existing videos except the source file

OBJECTS=$(aws s3api list-objects-v2 --bucket tidal --delimiter="/" --profile digitalocean --endpoint=https://nyc3.digitaloceanspaces.com --output text)

for ROW in $OBJECTS; do
  VIDEO_ID=$(echo $ROW | sed /COMMONPREFIXES/d | cut -d'/' -f1)

  if [ ! -z "$VIDEO_ID" ]
  then
    echo "VIDEO_ID: $VIDEO_ID"
    EXISTS=$(aws s3 ls s3://cdn.bken.io/v/${VIDEO_ID} --profile wasabi --recursive --endpoint=https://us-east-2.wasabisys.com | wc -l)

    if [ $EXISTS -eq 0 ]
    then
      # read -p "$VIDEO_ID was not found in the cdn, would you like to permenantly delete it from tidal?" -n 1 -r
      # echo
      # if [[ $REPLY =~ ^[Yy]$ ]]
      # then
        aws s3 rm s3://tidal/${VIDEO_ID} \
          --quiet \
          --recursive \
          --profile digitalocean \
          --endpoint=https://nyc3.digitaloceanspaces.com
      # fi
    else 
      aws s3 rm s3://tidal/${VIDEO_ID} \
        --quiet \
        --recursive \
        --exclude "source*" \
        --profile digitalocean \
        --endpoint=https://nyc3.digitaloceanspaces.com 
    fi
  fi

done