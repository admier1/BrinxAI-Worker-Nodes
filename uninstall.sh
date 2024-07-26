#!/bin/bash

# Set the user variable
USR=${USR:-"brinxai_nodes"}

# Stop the existing containers
docker stop ${USR}-worker-1 || docker stop root-worker-1
docker stop ${USR}-rembg-1 || docker stop root-rembg-1
docker stop ${USR}-text-ui-1 || docker stop root-text-ui-1

# Remove the existing containers
docker rm ${USR}-worker-1 || docker rm root-worker-1
docker rm ${USR}-rembg-1 || docker rm root-rembg-1
docker rm ${USR}-text-ui-1 || docker rm root-text-ui-1
