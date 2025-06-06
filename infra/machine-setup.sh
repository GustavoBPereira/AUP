#!/bin/bash

set -e

echo "Starting machine setup..."

echo "Updating package lists..."
sudo apt update -y

echo "Installing dependencies..."
sudo apt install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    certbot

echo "Installing Git..."
sudo apt install -y git


echo "Installing Docker..."

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo gpasswd -a $USER docker
newgrp docker

echo "Installation complete!"


#  sudo certbot certonly --standalone -d aup.rec.br
# 0 0 1 * * certbot renew --quiet && docker restart web
