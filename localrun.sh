#!/bin/sh

docker run -d \
  --name=casaos \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /var/run/docker.sock:/var/run/docker.sock\
  -v /root/casaos-in-docker/config/:/config \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cgroupns=host \
  --privileged \
  --shm-size="1gb" \
  --restart unless-stopped \
  casaos
