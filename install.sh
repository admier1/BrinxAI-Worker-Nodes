#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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

# Pull the worker image from Docker Hub
echo "Pulling Docker image admier/brinxai_nodes-worker..."
docker pull admier/brinxai_nodes-worker

# Create docker-compose.yml file
echo "Creating docker-compose.yml..."
if [ "$GPU_AVAILABLE" = true ]; then
    cat <<EOF > docker-compose.yml
version: '3.8'

services:
  worker:
    image: admier/brinxai_nodes-worker
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
      - DASHBOARD_PORT=\${DASHBOARD_PORT:-3030}
    ports:
      - "\${WORKER_PORT:-5011}:\${WORKER_PORT:-5011}"
      - "\${DASHBOARD_PORT:-3030}:\${DASHBOARD_PORT:-3030}"
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
    image: admier/brinxai_nodes-worker
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
      - DASHBOARD_PORT=\${DASHBOARD_PORT:-3030}
    ports:
      - "\${WORKER_PORT:-5011}:\${WORKER_PORT:-5011}"
      - "\${DASHBOARD_PORT:-3030}:\${DASHBOARD_PORT:-3030}"
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

# Create systemd service
echo "Creating systemd service for Docker Compose application..."
cat <<EOF | sudo tee /etc/systemd/system/docker-compose-app.service
[Unit]
Description=Docker Compose Application Service
Requires=docker.service
After=docker.service

[Service]
Restart=always
WorkingDirectory=$(pwd)
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
echo "Enabling and starting the systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable docker-compose-app.service
sudo systemctl start docker-compose-app.service

echo "Installation and setup completed successfully."
