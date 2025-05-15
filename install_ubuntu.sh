#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to validate UUID format
validate_uuid() {
    local uuid=$1
    if [[ $uuid =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Update package list and install dependencies
echo "Updating package list and installing dependencies..."
sudo apt-get update
sudo apt-get install -y curl gnupg lsb-release wget

# Check if GPU is available
echo "Checking GPU availability..."
GPU_AVAILABLE=false
if command -v nvidia-smi &> /dev/null
then
    echo "GPU detected. NVIDIA driver is installed."
    GPU_AVAILABLE=true
else
    echo "No GPU detected or NVIDIA driver not installed."
fi

# Prompt user for WORKER_PORT
read -p "Enter the port number for WORKER_PORT (default is 5011): " USER_PORT
USER_PORT=${USER_PORT:-5011}

# Prompt user for node_UUID
while true; do
    read -p "Enter the node_UUID (must be a valid UUID, e.g., 123e4567-e89b-12d3-a456-426614174000): " NODE_UUID
    if validate_uuid "$NODE_UUID"; then
        echo "Valid UUID provided."
        break
    else
        echo "Invalid UUID format. Please provide a valid UUID (e.g., 123e4567-e89b-12d3-a456-426614174000)."
    fi
done

# Create .env file with user-defined WORKER_PORT and node_UUID
echo "Creating .env file..."
cat <<EOF > .env
WORKER_PORT=$USER_PORT
NODE_UUID=$NODE_UUID
EOF

# Create docker-compose.yml file
echo "Creating docker-compose.yml..."
if [ "$GPU_AVAILABLE" = true ]; then
    cat <<EOF > docker-compose.yml
version: '3.8'

services:
  worker:
    image: admier/brinxai_nodes-worker:latest
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
      - NODE_UUID=\${NODE_UUID}
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

networks:
  brinxai-network:
    driver: bridge
    name: brinxai-network  # Explicitly set the network name
EOF
else
    cat <<EOF > docker-compose.yml
version: '3.8'

services:
  worker:
    image: admier/brinxai_nodes-worker:latest
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
      - NODE_UUID=\${NODE_UUID}
    ports:
      - "\${WORKER_PORT:-5011}:\${WORKER_PORT:-5011}"
    volumes:
      - ./generated_images:/usr/src/app/generated_images
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - brinxai-network

networks:
  brinxai-network:
    driver: bridge
    name: brinxai-network  # Explicitly set the network name
EOF
fi

# Start Docker containers using docker compose
echo "Starting Docker containers..."
docker compose up -d

echo "Installation and setup completed successfully."
