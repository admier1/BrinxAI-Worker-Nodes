#!/bin/bash

# Pull the latest images from Docker Hub
docker pull admier/brinxai_nodes-rembg:latest
docker pull admier/brinxai_nodes-rembg:latest
docker pull admier/brinxai_nodes-rembg:latest

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

# Start the Docker services
docker-compose up -d
