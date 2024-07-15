#!/bin/bash

# Pull the latest images from Docker Hub
docker pull admier/brinxai_nodes-rembg:latest
docker pull admier/brinxai_nodes-text-ui:latest
docker pull admier/brinxai_nodes-worker:latest

# Create a Docker Compose file
cat <<EOF > docker-compose.yml
version: '3'
services:
  text-ui:
    image: admier/text-ui:latest
    networks:
      - brinxai-network
    ports:
      - "127.0.0.1:7860:7860"
    expose:
      - "5000"
    volumes:
      - ./:/usr/src/app

  worker:
    image: admier/worker:latest
    networks:
      - brinxai-network
    ports:
      - "5011:5011"
    depends_on:
      - text-ui
      - rembg

  rembg:
    image: admier/rembg:latest
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

