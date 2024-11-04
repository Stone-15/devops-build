#!/bin/bash

IMAGE_NAME="web-app"

# Build the Docker image
docker build -t $IMAGE_NAME .

echo "Docker image $IMAGE_NAME built successfully."
