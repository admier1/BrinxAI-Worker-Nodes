#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

IMAGE_NAME="admier/brinxai_nodes-worker:latest"
CONTAINER_NAME="brinxai_worker_amd64"

# Function to validate UUID format
validate_uuid() {
    local uuid=$1
    if [[ $uuid =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Install dependencies (Arch Linux only)
echo "🔧 Updating package list and installing dependencies (Arch Linux)..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm curl gnupg wget docker docker-compose

# Enable and start Docker if not running
sudo systemctl enable --now docker

# Check if GPU is available
echo "🔍 Checking GPU availability..."
GPU_AVAILABLE=false
if command -v nvidia-smi &> /dev/null; then
    echo "✅ GPU detected. NVIDIA driver is installed."
    GPU_AVAILABLE=true
else
    echo "ℹ️ No GPU detected or NVIDIA driver not installed."
fi

# Prompt user for WORKER_PORT
read -p "Enter the port number for WORKER_PORT (default is 5011): " USER_PORT
USER_PORT=${USER_PORT:-5011}

# Prompt user for node_UUID
while true; do
    read -p "Enter the node_UUID (must be a valid UUID, e.g., 123e4567-e89b-12d3-a456-426614174000): " NODE_UUID
    if validate_uuid "$NODE_UUID"; then
        echo "✅ Valid UUID provided."
        break
    else
        echo "❌ Invalid UUID format. Please provide a valid UUID (e.g., 123e4567-e89b-12d3-a456-426614174000)."
    fi
done

# Create .env file with user-defined WORKER_PORT and node_UUID
echo "💾 Creating .env file..."
cat <<EOF > .env
WORKER_PORT=$USER_PORT
NODE_UUID=$NODE_UUID
USE_GPU=$GPU_AVAILABLE
CUDA_VISIBLE_DEVICES=""
EOF

# Create docker-compose.yml file
echo "📝 Creating docker-compose.yml..."
if [ "$GPU_AVAILABLE" = true ]; then
    cat <<EOF > docker-compose.yml
services:
  $CONTAINER_NAME:
    image: $IMAGE_NAME
    container_name: $CONTAINER_NAME
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
      - NODE_UUID=\${NODE_UUID}
      - USE_GPU=\${USE_GPU:-true}
      - CUDA_VISIBLE_DEVICES=\${CUDA_VISIBLE_DEVICES}
    ports:
      - "\${WORKER_PORT:-5011}:\${WORKER_PORT:-5011}"
    volumes:
      - ./generated_images:/usr/src/app/generated_images
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - brinxai-network
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
    runtime: nvidia
    restart: always
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

networks:
  brinxai-network:
    driver: bridge
    name: brinxai-network
EOF
else
    cat <<EOF > docker-compose.yml
services:
  $CONTAINER_NAME:
    image: $IMAGE_NAME
    container_name: $CONTAINER_NAME
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
      - NODE_UUID=\${NODE_UUID}
      - USE_GPU=\${USE_GPU:-false}
      - CUDA_VISIBLE_DEVICES=\${CUDA_VISIBLE_DEVICES}
    ports:
      - "\${WORKER_PORT:-5011}:\${WORKER_PORT:-5011}"
    volumes:
      - ./generated_images:/usr/src/app/generated_images
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - brinxai-network
    restart: always
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

networks:
  brinxai-network:
    driver: bridge
    name: brinxai-network
EOF
fi

# Clean up old container if it exists
echo "🧼 Removing old container if it exists..."
docker rm -f $CONTAINER_NAME || true

# Pull the latest Docker image
echo "🐳 Pulling latest image from Docker Hub..."
docker pull $IMAGE_NAME

# Start Docker containers using docker compose
echo "🚀 Starting Docker containers..."
docker compose up -d

# Deploy Watchtower to monitor and update the container
echo "📡 Deploying Watchtower to monitor and update the container..."
docker rm -f watchtower || true
docker run -d \
  --name watchtower \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --include-restarting \
  --label-enable \
  --schedule "0 0 4 * * *" # Run daily at 4 AM

# Check container status with delay
echo "🔍 Checking container status..."
sleep 5 # Wait for container to stabilize
docker ps -a --filter "name=$CONTAINER_NAME"

# Display container logs for debugging
echo "📜 Displaying container logs..."
CONTAINER_ID=$(docker ps -a -q --filter "name=$CONTAINER_NAME")
if [ -n "$CONTAINER_ID" ]; then
    docker logs "$CONTAINER_ID" || echo "ℹ️ No logs available."
else
    echo "❌ No container found with name '$CONTAINER_NAME'."
fi

# Verify if container is still running
echo "✅ Verifying container status after delay..."
if docker ps --filter "name=$CONTAINER_NAME" --format '{{.ID}}' | grep -q .; then
    echo "✅ Container is running successfully."
else
    echo "❌ Container failed to stay running. Please check the logs above for errors."
    echo "Running 'docker ps -a' for more details:"
    docker ps -a --filter "name=$CONTAINER_NAME"
fi

echo "🎉 Installation and setup completed successfully. Watchtower will auto-update the container daily when a new version of '$IMAGE_NAME' is available!"
