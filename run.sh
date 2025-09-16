#!/bin/bash

APP_NAME="dash_app_container"
IMAGE_NAME="dash_app_image"

# Detect local architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    PLATFORM="linux/amd64"
elif [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    PLATFORM="linux/arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

echo "Building Docker image for local platform: $PLATFORM"
docker buildx build --platform $PLATFORM -t $IMAGE_NAME --load .

# Remove existing container
if [ "$(docker ps -aq -f name=^/${APP_NAME}$)" ]; then
    echo "Container $APP_NAME already exists. Removing..."
    docker rm -f $APP_NAME
fi

# Run container in background
echo "Starting container..."
docker run --name $APP_NAME -p 8050:8050 $IMAGE_NAME &

CONTAINER_PID=$!
echo "Dash app running in Docker (Gunicorn). Press Ctrl+C to stop..."

# Graceful shutdown
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

