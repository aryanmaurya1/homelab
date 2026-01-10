docker run -d -e BUCKET_NAME="immich-data-upload" \
  --restart always \
  --mount type=bind,source="/root/immich_data",target=/data,bind-propagation=shared \
  -v "/root/credentials:/credentials:ro" \
  --device /dev/fuse \
  --cap-add SYS_ADMIN \
  --security-opt apparmor=unconfined \
  gcsfuse:v1.0
