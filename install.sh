#!/bin/bash

# Function to check if Docker image exists on Docker Hub
check_image_exists() {
    local image_name="$1"
    if ! docker pull "$image_name" &> /dev/null; then
        echo "Error: Docker image $image_name does not exist on Docker Hub."
        exit 1
    fi
}

# Check and pull the latest images from Docker Hub
check_image_exists "admier/brinxai_nodes-rembg:latest"
check_image_exists "admier/brinxai_nodes-text-ui:latest"
check_image_exists "admier/brinxai_nodes-worker:latest"

# Create a Docker Compose file
cat <<EOF > docker-compose.yml
version: '3'
services:
  text-ui:
    image: admier/brinxai_nodes-text-ui:latest
    networks:
      - brinxai-network
    ports:
      - "127.0.0.1:7860:7860"
    expose:
      - "5000"
    volumes:
      - ./:/usr/src/app

  worker:
    image: admier/brinxai_nodes-worker:latest
    networks:
      - brinxai-network
    ports:
      - "5011:5011"
    depends_on:
      - text-ui
      - rembg

  rembg:
    image: admier/brinxai_nodes-rembg:latest
    networks:
      - brinxai-network
    expose:
      - "7000"

networks:
  brinxai-network:
    driver: bridge
EOF

# Check if docker-compose or docker compose is available and start the services
if command -v docker-compose &> /dev/null
then
    docker-compose up -d
elif command -v docker &> /dev/null && docker compose version &> /dev/null
then
    docker compose up -d
else
    echo "Neither docker-compose nor docker compose is available. Please install Docker Compose."
    exit 1
fi
