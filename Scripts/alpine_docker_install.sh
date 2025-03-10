#!/bin/sh

# Step 1: Enable the Community Repository
echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
apk update

# Step 2: Install Docker and Docker Compose
apk add --no-cache docker docker-compose

# Step 3: Start and Enable Docker
service docker start
rc-update add docker boot

# Step 4: Verify Docker Installation
docker info

echo "Docker installation completed successfully!"
echo "Running a test container..."
docker run hello-world
