#!/bin/bash

# cleanup
rm -rf ffmpeg.zip ffmpeg

# package static build
curl -O https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz
tar xf ffmpeg-git-amd64-static.tar.xz
rm ffmpeg-git-amd64-static.tar.xz
mv ffmpeg-git-*-amd64-static ffmpeg

# zip it up
zip -r ffmpeg ffmpeg

# upload it to s3
aws s3 cp ./ffmpeg.zip s3://bken-layers/ffmpeg/ffmpeg.zip

# create layer in aws
aws lambda publish-layer-version \
  --layer-name ffmpeg \
  --description "ffmpeg" \
  --compatible-runtimes provided.al2 provided \
  --content S3Bucket=bken-layers,S3Key=ffmpeg/ffmpeg.zip

# cleanup
rm -rf ffmpeg.zip ffmpeg