#!/bin/bash

# Set the user variable
USR=${USR:-"brinxai_nodes"}

# Define an array of container names
containers=(
  "${USR}-worker-1"
  "root-worker-1"
  "ai_worker_1"
  "${USR}-rembg-1"
  "root-rembg-1"
  "ai_rembg_1"
  "${USR}-text-ui-1"
  "root-text-ui-1"
  "ai_text-ui_1"
)

# Stop Docker service
echo "Stopping Docker service..."
sudo systemctl stop docker.service

# Stop the existing containers
for container in "${containers[@]}"; do
  docker stop $container 2>/dev/null && echo "Stopped $container"
done

# Remove the existing containers
for container in "${containers[@]}"; do
  docker rm $container 2>/dev/null && echo "Removed $container"
done

# Remove Docker images
docker rmi admier/brinxai_nodes-worker 2>/dev/null && echo "Removed Docker image admier/brinxai_nodes-worker"

# Remove Docker volumes
docker volume prune -f

# Remove Docker networks
docker network prune -f

# Remove generated files and directories
rm -rf ./generated_images
rm -rf .env
rm -rf docker-compose.yml

echo "Uninstallation and cleanup completed successfully."
