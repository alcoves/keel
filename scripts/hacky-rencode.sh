#!/bin/bash

# This script helps prepare for a re-encoding of all tidal videos
# It goes without saying, this script is very destructive.

# PROCEED WITH CAUTION

# Delete everything in the tidal bucket
aws s3 rm s3://tidal/ --recursive --profile digitalocean --endpoint https://nyc3.digitaloceanspaces.com

# Wiping the cdn is not a requirement, but if the file structure has changed
# then duplicate files are possible (they would get cleaned up in a user delete process though)
# Also the ingest job should just handle this cleaning process for us
# Delete everything in the cdn v/ prefix expect for source.* videos
# /v/ must contain only videos, literally everything will get wiped
rclone delete wasabi:cdn.bken.io/v/ --exclude "source.*" --dry-run

# Query the bken database and get a list of all videos

# Create ingest jobs for all the videos to re-encode them
for i in "${arr[@]}"; do
  nomad job dispatch -detach \
    -meta s3_in=s3://cdn.bken.io/v/${i}/source.mp4 \
    -meta video_id=${i} \
    ingest
done