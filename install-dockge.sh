#!/bin/bash

# Set Variables
STACKS_DIR="/opt/stacks"
DOCKER_COMPOSE_URL="https://dockge.kuma.pet/compose.yaml?port=5001&stacksPath=%2Fopt%2Fstacks"

echo "---- Starting DockGE Installation ----"

# Ensure root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Update System
echo "Updating packages..."
apt-get update -y && apt-get upgrade -y

# Create Stacks Directory
echo "Creating directory structure..."
mkdir -p "$STACKS_DIR"

# Download Docker Compose File for DockGE
echo "Downloading official Docker Compose file..."
wget -O "$STACKS_DIR/docker-compose.yml" "$DOCKER_COMPOSE_URL"

# Deploy Docker Stack
echo "Deploying DockGE with Docker Compose..."
cd "$STACKS_DIR" && docker compose up -d

echo "---- DockGE Installation Completed ----"
echo "Access DockGE at your server's IP address with port 5001."
