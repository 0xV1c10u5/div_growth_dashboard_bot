#!/bin/bash

APP_NAME="dash_app_container"
IMAGE_NAME="dash_app_image"

# Build Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME .

# Remove existing container if it exists
if [ "$(docker ps -aq -f name=^/${APP_NAME}$)" ]; then
    echo "Container $APP_NAME already exists. Removing..."
    docker rm -f $APP_NAME
fi

# Run container in background
echo "Starting container..."
docker run --name $APP_NAME -p 8050:8050 $IMAGE_NAME &

CONTAINER_PID=$!

echo "Dash app running in Docker (Gunicorn). Press Ctrl+C to stop..."

# Handle Ctrl+C
cleanup() {
    echo ""
    echo "Stopping container..."
    docker stop $APP_NAME
    echo "Removing container..."
    docker rm $APP_NAME
    exit 0
}

trap cleanup SIGINT
wait $CONTAINER_PID

